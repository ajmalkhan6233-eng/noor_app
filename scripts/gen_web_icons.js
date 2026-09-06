// Web favicon/PWA icons — still Flutter's unbranded default template
// (stock Flutter logo, "A new Flutter project" description, Flutter's
// default blue theme color) since this project has never shipped to
// web; the web preview build used for icon/layout review during
// testing exposed this. Same glossy 3D orb as the Android launcher
// icon (scripts/gen_launcher_icon.js) and the in-app bottom-nav badges.
// Run: node scripts/gen_web_icons.js
const fs = require('fs');
const path = require('path');
const { encodePNG } = require('./icon_gfx');
const { drawOrb } = require('./icon_orb');

const webRoot = path.join(__dirname, '..', 'web');

function writeOrb(outPath, size) {
  const px = drawOrb(size, size * 0.48, { drawSphereFill: true });
  fs.writeFileSync(outPath, encodePNG(size, size, px));
  console.log(`Wrote ${outPath} (${size}x${size})`);
}

function writeMaskableOrb(outPath, size) {
  // Maskable icons need the motif kept inside a smaller safe zone
  // since PWA installers can crop to a circle/squircle.
  const px = drawOrb(size, size * 0.38, { drawSphereFill: true });
  fs.writeFileSync(outPath, encodePNG(size, size, px));
  console.log(`Wrote ${outPath} (${size}x${size}, maskable safe zone)`);
}

writeOrb(path.join(webRoot, 'favicon.png'), 32);
writeOrb(path.join(webRoot, 'icons', 'Icon-192.png'), 192);
writeOrb(path.join(webRoot, 'icons', 'Icon-512.png'), 512);
writeMaskableOrb(path.join(webRoot, 'icons', 'Icon-maskable-192.png'), 192);
writeMaskableOrb(path.join(webRoot, 'icons', 'Icon-maskable-512.png'), 512);
