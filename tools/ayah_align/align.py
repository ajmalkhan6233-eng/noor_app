# Bismillahir Rahmanir Raheem — watermark: ALLAH
#
# One-time, cloud-only ayah timing generator (2026-11-19).
# Lines up each bundled CC BY recitation (Moeed Alharthi, see
# assets/quran/audio/*/README.md) with the verified Tanzil text using
# CTC forced alignment:
#   model : jonatasgrosman/wav2vec2-large-xlsr-53-arabic (Apache-2.0)
#   align : torchaudio.functional.forced_align (BSD)
# Output: per surah, the start time (ms) of every ayah + a quality score.
# Nothing here ships in the app except the resulting numbers.
import json, os, re, subprocess, sys, unicodedata
import numpy as np
import torch, torchaudio
from transformers import Wav2Vec2ForCTC, Wav2Vec2Processor

MODEL = "jonatasgrosman/wav2vec2-large-xlsr-53-arabic"
SR = 16000
FRAME_S = 0.02  # wav2vec2: one frame per 320 samples
ROOT = sys.argv[1] if len(sys.argv) > 1 else "."
OUT = sys.argv[2] if len(sys.argv) > 2 else "ayah_timings.json"
ISTIADHA = "اعوذ بالله من الشيطان الرجيم"

def load_quran():
    ayahs = {}
    with open(os.path.join(ROOT, "assets/quran/tanzil-uthmani.txt"), encoding="utf-8") as f:
        for line in f:
            parts = line.rstrip("\n").split("|")
            if len(parts) == 3 and parts[0].isdigit():
                ayahs.setdefault(int(parts[0]), []).append(parts[2])
    return ayahs

# Quranic marks / diacritics the model's plain-letter vocabulary lacks.
DROP = set(range(0x064B, 0x0660)) | {0x0670, 0x0640} | set(range(0x06D6, 0x06EE))
MAP = {"ٱ": "ا", "آ": "ا", "أ": "ا", "إ": "ا"}

def normalize(text, vocab):
    out = []
    for ch in unicodedata.normalize("NFC", text):
        if ord(ch) in DROP:
            continue
        ch = MAP.get(ch, ch)
        if ch.isspace():
            out.append("|")
        elif ch in vocab:
            out.append(ch)
        else:
            base = unicodedata.normalize("NFKD", ch)[0]
            if base in vocab:
                out.append(base)
    s = re.sub(r"\|+", "|", "".join(out)).strip("|")
    return s

def audio_path(surah):
    for sub in ("juz_amma", "popular"):
        p = os.path.join(ROOT, f"assets/quran/audio/{sub}/{surah:03d}.m4a")
        if os.path.exists(p):
            return p
    return None

def decode(path):
    raw = subprocess.run(["ffmpeg", "-v", "quiet", "-i", path, "-ac", "1", "-ar", str(SR), "-f", "f32le", "-"],
                         capture_output=True, check=True).stdout
    return np.frombuffer(raw, dtype=np.float32)

@torch.inference_mode()
def emissions(model, processor, wav):
    chunk = 320 * 1000  # 20 s, frame-aligned
    outs = []
    for i in range(0, len(wav), chunk):
        piece = wav[i:i + chunk]
        if len(piece) < 400:
            break
        inputs = processor(piece, sampling_rate=SR, return_tensors="pt", padding=False)
        logits = model(inputs.input_values).logits[0]
        outs.append(torch.log_softmax(logits, dim=-1))
    return torch.cat(outs, dim=0)

def align(em, token_ids, blank):
    targets = torch.tensor([token_ids], dtype=torch.int32)
    labels, scores = torchaudio.functional.forced_align(em.unsqueeze(0), targets, blank=blank)
    return labels[0].numpy(), scores[0].exp().numpy()

def spans(labels, scores, blank):
    """Frame index where each target token (in order) starts and ends."""
    starts, ends, probs = [], [], []
    prev = blank
    for t, (lab, sc) in enumerate(zip(labels, scores)):
        if lab != blank and (lab != prev or (starts and t != ends[-1] + 1)):
            starts.append(t); ends.append(t); probs.append([sc])
        elif lab != blank:
            ends[-1] = t; probs[-1].append(sc)
        prev = lab
    return starts, ends, [float(np.mean(p)) for p in probs]

def run_surah(model, processor, vocab, blank, surah, texts):
    em = emissions(model, processor, decode(audio_path(surah)))
    best = None
    for with_istiadha in (False, True):
        pieces = ([normalize(ISTIADHA, vocab)] if with_istiadha else []) + [normalize(t, vocab) for t in texts]
        ids, owner = [], []
        for idx, piece in enumerate(pieces):
            if idx and ids:
                ids.append(vocab["|"]); owner.append(-1)
            for ch in piece:
                ids.append(vocab[ch]); owner.append(idx - (1 if with_istiadha else 0))
        labels, scores = align(em, ids, blank)
        st, en, pr = spans(labels, scores, blank)
        if len(st) != len(ids):
            continue
        mean = float(np.mean(pr))
        if best is None or mean > best[0]:
            best = (mean, with_istiadha, st, en, pr, owner)
    if best is None:
        return None
    mean, with_istiadha, st, en, pr, owner = best
    n = len(texts)
    first = [None] * n; last = [None] * n; conf = [[] for _ in range(n)]
    for i, o in enumerate(owner):
        if o < 0:
            continue
        if first[o] is None:
            first[o] = st[i]
        last[o] = en[i]; conf[o].append(pr[i])
    starts_ms = []
    for a in range(n):
        s = first[a]
        if a > 0:  # start in the middle of the pause before the ayah
            gap = s - last[a - 1]
            s = last[a - 1] + gap // 2 if gap < 75 else s - 10
        else:
            s = max(0, s - 10)
        starts_ms.append(int(round(s * FRAME_S * 1000)))
    return {
        "surah": surah,
        "ayahs": n,
        "istiadha_in_recording": with_istiadha,
        "duration_ms": int(round(em.shape[0] * FRAME_S * 1000)),
        "start_ms": starts_ms,
        "confidence": [round(float(np.mean(c)), 3) for c in conf],
        "mean_confidence": round(mean, 3),
    }

def main():
    torch.set_num_threads(os.cpu_count() or 4)
    processor = Wav2Vec2Processor.from_pretrained(MODEL)
    model = Wav2Vec2ForCTC.from_pretrained(MODEL).eval()
    vocab = processor.tokenizer.get_vocab()
    blank = vocab.get(processor.tokenizer.pad_token, 0)
    print("vocab size", len(vocab), "blank", blank, "has |", "|" in vocab, flush=True)
    quran = load_quran()
    surahs = [s for s in range(1, 115) if audio_path(s)]
    only = os.environ.get("SURAHS")
    if only:
        surahs = [int(x) for x in only.split(",")]
    result = {"model": MODEL, "reciter": "Moeed Alharthi (CC BY 4.0)", "surahs": {}}
    for s in surahs:
        r = run_surah(model, processor, vocab, blank, s, quran[s])
        print(s, "FAILED" if r is None else f"ok mean={r['mean_confidence']} istiadha={r['istiadha_in_recording']} "
              f"low={sum(1 for c in r['confidence'] if c < 0.5)}", flush=True)
        if r:
            result["surahs"][str(s)] = r
        with open(OUT, "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=1)

if __name__ == "__main__":
    main()
