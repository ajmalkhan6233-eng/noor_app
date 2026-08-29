// One-off generator for the noor launcher icon: gold crescent + cyan
// ring on an obsidian circle, drawn via raw pixel math (no canvas
// dependency available in this environment) and encoded as PNG by
// hand using Node's built-in zlib. Run: node scripts/gen_launcher_icon.js
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

const OBSIDIAN = [0x05, 0x07, 0x0b];
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
  ihdr[8] = 8; // bit depth
  ihdr[9] = 6; // color type RGBA
  ihdr[10] = 0;
  ihdr[11] = 0;
  ihdr[12] = 0;

  const stride = width * 4;
  const raw = Buffer.alloc((stride + 1) * height);
  for (let y = 0; y < height; y++) {
    raw[y * (stride + 1)] = 0; // no filter
    rgbaPixels.copy(raw, y * (stride + 1) + 1, y * stride, y * stride + stride);
  }
  const idat = zlib.deflateSync(raw, { level: 9 });

  return Buffer.concat([
    sig,
    chunk('IHDR', ihdr),
    chunk('IDAT', idat),
    chunk('IEND', Buffer.alloc(0)),
  ]);
}

function drawIcon(size) {
  const px = Buffer.alloc(size * size * 4);
  const cx = size / 2;
  const cy = size / 2;
  const r = size * 0.48;
  const ringWidth = size * 0.035;
  const moonR = size * 0.30;
  // Crescent: outer circle at (cx, cy) radius moonR minus an offset
  // inner circle that carves out the sliver.
  const cutCx = cx + moonR * 0.55;
  const cutCy = cy - moonR * 0.12;
  const cutR = moonR * 0.92;

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const dx = x - cx + 0.5;
      const dy = y - cy + 0.5;
      const dist = Math.sqrt(dx * dx + dy * dy);
      let color = null; // null = transparent
      let alpha = 0;

      if (dist <= r) {
        color = OBSIDIAN;
        alpha = 255;
        // cyan ring near the edge
        if (dist >= r - ringWidth) {
          color = CYAN;
        } else {
          // gold crescent moon
          const mdx = x - cx + 0.5;
          const mdy = y - cy + 0.5;
          const moonDist = Math.sqrt(mdx * mdx + mdy * mdy);
          if (moonDist <= moonR) {
            const cutDx = x - cutCx + 0.5;
            const cutDy = y - cutCy + 0.5;
            const cutDist = Math.sqrt(cutDx * cutDx + cutDy * cutDy);
            if (cutDist > cutR) {
              color = GOLD;
            }
          }
        }
      }

      const idx = (y * size + x) * 4;
      if (color) {
        px[idx] = color[0];
        px[idx + 1] = color[1];
        px[idx + 2] = color[2];
        px[idx + 3] = alpha;
      } else {
        px[idx] = 0;
        px[idx + 1] = 0;
        px[idx + 2] = 0;
        px[idx + 3] = 0;
      }
    }
  }
  return encodePNG(size, size, px);
}

const densities = {
  'mipmap-mdpi': 48,
  'mipmap-hdpi': 72,
  'mipmap-xhdpi': 96,
  'mipmap-xxhdpi': 144,
  'mipmap-xxxhdpi': 192,
};

const resRoot = path.join(__dirname, '..', 'android', 'app', 'src', 'main', 'res');
for (const [dir, size] of Object.entries(densities)) {
  const outPath = path.join(resRoot, dir, 'ic_launcher.png');
  const png = drawIcon(size);
  fs.writeFileSync(outPath, png);
  console.log(`Wrote ${outPath} (${size}x${size}, ${png.length} bytes)`);
}
