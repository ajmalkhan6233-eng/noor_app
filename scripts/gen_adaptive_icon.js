// Generates the adaptive-icon foreground layer: the same gold
// crescent + cyan ring motif as gen_launcher_icon.js's flat icon, but
// with a transparent background and scaled to sit inside Android's
// adaptive-icon "safe zone" (a 66dp circle centred in the 108dp
// canvas — content outside that circle can be clipped by a launcher's
// mask/parallax, so the visible motif is kept well inside it, at the
// same 0.48-of-radius proportions the flat icon already uses, just
// scaled down to a 0.30-of-half-canvas outer radius instead of 0.48).
// The background layer is a plain solid color (see
// android/app/src/main/res/values/ic_launcher_background.xml) — no
// PNG needed for a flat fill.
// Run: node scripts/gen_adaptive_icon.js
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const CYAN = [0x00, 0xf2, 0xfe];
const GOLD = [0xff, 0xb7, 0x03];

function crc32(buf) {
  let c;
  const table = crc32.table || (crc32.table = (() => {
    const t = [];
    for (let n = 0; n < 256; n++) {
      c = n;
      for (let k = 0; k < 8; k++) c = c & 1 ? (0xedb88320 ^ (c >>> 1)) : (c >>> 1);
      t[n] = c;
    }
    return t;
  })());
  let crc = 0xffffffff;
  for (let i = 0; i < buf.length; i++) crc = table[(crc ^ buf[i]) & 0xff] ^ (crc >>> 8);
  return (crc ^ 0xffffffff) >>> 0;
}

function chunk(type, data) {
  const len = Buffer.alloc(4);
  len.writeUInt32BE(data.length, 0);
  const typeBuf = Buffer.from(type, 'ascii');
  const crcBuf = Buffer.alloc(4);
  crcBuf.writeUInt32BE(crc32(Buffer.concat([typeBuf, data])), 0);
  return Buffer.concat([len, typeBuf, data, crcBuf]);
}

function encodePNG(width, height, rgbaPixels) {
  const sig = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(width, 0);
  ihdr.writeUInt32BE(height, 4);
  ihdr[8] = 8;
  ihdr[9] = 6;
  const stride = width * 4;
  const raw = Buffer.alloc((stride + 1) * height);
  for (let y = 0; y < height; y++) {
    raw[y * (stride + 1)] = 0;
    rgbaPixels.copy(raw, y * (stride + 1) + 1, y * stride, y * stride + stride);
  }
  const idat = zlib.deflateSync(raw, { level: 9 });
  return Buffer.concat([sig, chunk('IHDR', ihdr), chunk('IDAT', idat), chunk('IEND', Buffer.alloc(0))]);
}

function drawForeground(size) {
  const px = Buffer.alloc(size * size * 4);
  const cx = size / 2;
  const cy = size / 2;
  const r = size * 0.30; // safe-zone outer radius, not 0.48 (flat icon's full-bleed radius)
  const ringWidth = size * 0.022;
  const moonR = r * 0.63;
  const cutCx = cx + moonR * 0.55;
  const cutCy = cy - moonR * 0.12;
  const cutR = moonR * 0.92;

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const dx = x - cx + 0.5;
      const dy = y - cy + 0.5;
      const dist = Math.sqrt(dx * dx + dy * dy);
      let color = null;
      if (dist <= r && dist >= r - ringWidth) {
        color = CYAN;
      } else if (dist < moonR) {
        const cutDist = Math.sqrt((x - cutCx + 0.5) ** 2 + (y - cutCy + 0.5) ** 2);
        if (cutDist > cutR) color = GOLD;
      }
      const idx = (y * size + x) * 4;
      if (color) {
        px[idx] = color[0];
        px[idx + 1] = color[1];
        px[idx + 2] = color[2];
        px[idx + 3] = 255;
      }
    }
  }
  return encodePNG(size, size, px);
}

const densities = {
  'mipmap-mdpi': 108,
  'mipmap-hdpi': 162,
  'mipmap-xhdpi': 216,
  'mipmap-xxhdpi': 324,
  'mipmap-xxxhdpi': 432,
};

const resRoot = path.join(__dirname, '..', 'android', 'app', 'src', 'main', 'res');
for (const [dir, size] of Object.entries(densities)) {
  const outPath = path.join(resRoot, dir, 'ic_launcher_foreground.png');
  const png = drawForeground(size);
  fs.writeFileSync(outPath, png);
  console.log(`Wrote ${outPath} (${size}x${size}, ${png.length} bytes)`);
}
