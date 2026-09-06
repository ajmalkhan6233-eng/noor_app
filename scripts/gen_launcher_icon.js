// Legacy flat launcher icon (pre-Android-26 devices, and any surface
// that reads @mipmap/ic_launcher's density PNGs directly rather than
// the adaptive-icon XML): the same glossy 3D orb as the redesigned
// bottom-nav badges, self-contained on one transparent-outside-circle
// PNG. Run: node scripts/gen_launcher_icon.js
const fs = require('fs');
const path = require('path');
const { encodePNG } = require('./icon_gfx');
const { drawOrb } = require('./icon_orb');

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
  const px = drawOrb(size, size * 0.48, { drawSphereFill: true });
  fs.writeFileSync(outPath, encodePNG(size, size, px));
  console.log(`Wrote ${outPath} (${size}x${size})`);
}
