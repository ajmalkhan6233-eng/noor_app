// Shared raw-pixel PNG helpers for the noor icon generator scripts.
// No canvas dependency available in this environment, so PNGs are
// built by hand (per-pixel RGBA -> zlib-deflated scanlines -> chunks).
const zlib = require('zlib');

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
  const stride = width * 4;
  const raw = Buffer.alloc((stride + 1) * height);
  for (let y = 0; y < height; y++) {
    raw[y * (stride + 1)] = 0; // no filter
    rgbaPixels.copy(raw, y * (stride + 1) + 1, y * stride, y * stride + stride);
  }
  const idat = zlib.deflateSync(raw, { level: 9 });
  return Buffer.concat([sig, chunk('IHDR', ihdr), chunk('IDAT', idat), chunk('IEND', Buffer.alloc(0))]);
}

// smooth 0..1 falloff, coverage=1 well inside the edge, 0 well outside
function edgeCoverage(dist, edge, aa) {
  if (dist <= edge - aa) return 1;
  if (dist >= edge + aa) return 0;
  const t = (dist - (edge - aa)) / (2 * aa);
  return 1 - (t * t * (3 - 2 * t)); // smoothstep
}

function lerp(a, b, t) {
  return a + (b - a) * t;
}

function lerpColor(c1, c2, t) {
  t = Math.max(0, Math.min(1, t));
  return [lerp(c1[0], c2[0], t), lerp(c1[1], c2[1], t), lerp(c1[2], c2[2], t)];
}

// Blends src (with its own alpha 0..1) over dst RGB, returns blended RGB.
function over(dst, src, srcAlpha) {
  return [
    lerp(dst[0], src[0], srcAlpha),
    lerp(dst[1], src[1], srcAlpha),
    lerp(dst[2], src[2], srcAlpha),
  ];
}

module.exports = { encodePNG, edgeCoverage, lerp, lerpColor, over };
