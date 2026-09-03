// Generates the Qibla needle as two static PNG assets (gold/cyan),
// replacing the CustomPainter-drawn needle (compass_needle_painter.dart)
// with a pre-rendered bitmap rotated via Transform.rotate at runtime —
// no per-frame Canvas/Path draw calls, the suspected actual cause of
// the GPU/compositor rendering glitch (2026-09-03 direct request).
// Same silhouette CompassNeedlePainter drew: a long tapered point, a
// tail, a horizontal cross-stroke, and a center jewel dot.

const fs = require('fs');
const zlib = require('zlib');
const path = require('path');

const SIZE = 240;
const CENTER = SIZE / 2;

function makeCanvas(size) {
  const px = new Uint8Array(size * size * 4); // RGBA, transparent
  return px;
}

function setPixel(px, size, x, y, r, g, b, a) {
  if (x < 0 || y < 0 || x >= size || y >= size) return;
  const i = (y * size + x) * 4;
  // Simple alpha-over blend against existing (usually transparent) pixel.
  const existingA = px[i + 3] / 255;
  const outA = a + existingA * (1 - a);
  if (outA <= 0) return;
  px[i] = Math.round((r * a + px[i] * existingA * (1 - a)) / outA);
  px[i + 1] = Math.round((g * a + px[i + 1] * existingA * (1 - a)) / outA);
  px[i + 2] = Math.round((b * a + px[i + 2] * existingA * (1 - a)) / outA);
  px[i + 3] = Math.round(outA * 255);
}

function fillTriangle(px, size, p0, p1, p2, color, alpha) {
  const minX = Math.max(0, Math.floor(Math.min(p0[0], p1[0], p2[0])));
  const maxX = Math.min(size - 1, Math.ceil(Math.max(p0[0], p1[0], p2[0])));
  const minY = Math.max(0, Math.floor(Math.min(p0[1], p1[1], p2[1])));
  const maxY = Math.min(size - 1, Math.ceil(Math.max(p0[1], p1[1], p2[1])));
  const sign = (a, b, c) => (a[0] - c[0]) * (b[1] - c[1]) - (b[0] - c[0]) * (a[1] - c[1]);
  for (let y = minY; y <= maxY; y++) {
    for (let x = minX; x <= maxX; x++) {
      const pt = [x + 0.5, y + 0.5];
      const d1 = sign(pt, p0, p1);
      const d2 = sign(pt, p1, p2);
      const d3 = sign(pt, p2, p0);
      const hasNeg = d1 < 0 || d2 < 0 || d3 < 0;
      const hasPos = d1 > 0 || d2 > 0 || d3 > 0;
      if (!(hasNeg && hasPos)) {
        setPixel(px, size, x, y, color[0], color[1], color[2], alpha);
      }
    }
  }
}

function strokeLine(px, size, x0, y0, x1, y1, width, color, alpha) {
  const dx = x1 - x0, dy = y1 - y0;
  const len = Math.hypot(dx, dy);
  const nx = -dy / len, ny = dx / len;
  const hw = width / 2;
  fillTriangle(px, size, [x0 + nx * hw, y0 + ny * hw], [x1 + nx * hw, y1 + ny * hw], [x1 - nx * hw, y1 - ny * hw], color, alpha);
  fillTriangle(px, size, [x0 + nx * hw, y0 + ny * hw], [x1 - nx * hw, y1 - ny * hw], [x0 - nx * hw, y0 - ny * hw], color, alpha);
}

function fillCircle(px, size, cx, cy, r, color, alpha) {
  for (let y = Math.floor(cy - r); y <= Math.ceil(cy + r); y++) {
    for (let x = Math.floor(cx - r); x <= Math.ceil(cx + r); x++) {
      if ((x - cx) ** 2 + (y - cy) ** 2 <= r * r) setPixel(px, size, x, y, color[0], color[1], color[2], alpha);
    }
  }
}

function crc32(buf) {
  let crc = 0xFFFFFFFF;
  for (let i = 0; i < buf.length; i++) {
    crc ^= buf[i];
    for (let k = 0; k < 8; k++) crc = (crc & 1) ? (0xEDB88320 ^ (crc >>> 1)) : (crc >>> 1);
  }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

function chunk(type, data) {
  const len = Buffer.alloc(4); len.writeUInt32BE(data.length);
  const typeBuf = Buffer.from(type, 'ascii');
  const crcBuf = Buffer.alloc(4);
  crcBuf.writeUInt32BE(crc32(Buffer.concat([typeBuf, data])));
  return Buffer.concat([len, typeBuf, data, crcBuf]);
}

function encodePNG(size, px) {
  const stride = size * 4;
  const raw = Buffer.alloc(size * (stride + 1));
  for (let y = 0; y < size; y++) {
    raw[y * (stride + 1)] = 0;
    Buffer.from(px.buffer, y * stride, stride).copy(raw, y * (stride + 1) + 1);
  }
  const idat = zlib.deflateSync(raw);
  const sig = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(size, 0);
  ihdr.writeUInt32BE(size, 4);
  ihdr[8] = 8; ihdr[9] = 6; ihdr[10] = 0; ihdr[11] = 0; ihdr[12] = 0;
  return Buffer.concat([sig, chunk('IHDR', ihdr), chunk('IDAT', idat), chunk('IEND', Buffer.alloc(0))]);
}

const outDir = path.join(__dirname, '..', 'assets', 'qibla');
fs.mkdirSync(outDir, { recursive: true });

const gold = [0xFF, 0xB7, 0x03]; // context.colors.gold
const cyan = [0x00, 0xF2, 0xFE]; // context.colors.cyan

fs.writeFileSync(path.join(outDir, 'needle_gold.png'), encodePNG(SIZE, drawNeedle(gold)));
fs.writeFileSync(path.join(outDir, 'needle_cyan.png'), encodePNG(SIZE, drawNeedle(cyan)));

function drawNeedle(tipColor) {
  const px = makeCanvas(SIZE);
  const tipY = -SIZE / 2 + 12;
  const crossReach = SIZE * 0.14;
  fillTriangle(px, SIZE, [CENTER - 7, CENTER], [CENTER, CENTER + tipY], [CENTER + 7, CENTER], tipColor, 1.0);
  fillTriangle(px, SIZE, [CENTER, CENTER], [CENTER, CENTER + SIZE / 2 - 20], [CENTER - 5, CENTER], [0x3B, 0x3C, 0x42], 0.55);
  strokeLine(px, SIZE, CENTER - crossReach, CENTER, CENTER + crossReach, CENTER, 2, gold, 0.8);
  fillCircle(px, SIZE, CENTER, CENTER, 3, gold, 1.0);
  return px;
}

console.log('Generated assets/qibla/needle_gold.png and needle_cyan.png at', SIZE, 'x', SIZE);
