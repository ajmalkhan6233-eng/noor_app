// Adaptive icon (API 26+) — the real thing shown in the launcher and,
// critically, by Android 12+'s system SplashScreen API before Flutter
// ever loads (values-v31/styles.xml's windowSplashScreenAnimatedIcon
// resolves @mipmap/ic_launcher to this adaptive-icon XML on any modern
// device, not the flat mipmap-*dpi PNGs). Generates two layers: a
// full-bleed gradient background bitmap and a ring+crescent+highlight
// foreground sized to the adaptive-icon safe zone — the same glossy
// orb motif as the redesigned bottom-nav badges, split across layers
// so it survives circle/squircle/rounded-square launcher masking.
// Run: node scripts/gen_adaptive_icon.js
const fs = require('fs');
const path = require('path');
const { encodePNG } = require('./icon_gfx');
const { drawOrb, drawBackgroundGradient } = require('./icon_orb');

// Adaptive icon canvas is 108dp; the safe zone (content guaranteed not
// to be clipped by any launcher mask) is a 66dp circle centred in it.
const densities = {
  'mipmap-mdpi': 108,
  'mipmap-hdpi': 162,
  'mipmap-xhdpi': 216,
  'mipmap-xxhdpi': 324,
  'mipmap-xxxhdpi': 432,
};

const resRoot = path.join(__dirname, '..', 'android', 'app', 'src', 'main', 'res');
for (const [dir, size] of Object.entries(densities)) {
  const bgPath = path.join(resRoot, dir, 'ic_launcher_background.png');
  fs.writeFileSync(bgPath, encodePNG(size, size, drawBackgroundGradient(size)));
  console.log(`Wrote ${bgPath} (${size}x${size})`);

  const fgPath = path.join(resRoot, dir, 'ic_launcher_foreground.png');
  const safeZoneRadius = size * (33 / 108);
  const fg = drawOrb(size, safeZoneRadius, { drawSphereFill: false, rimAlpha: 0.9 });
  fs.writeFileSync(fgPath, encodePNG(size, size, fg));
  console.log(`Wrote ${fgPath} (${size}x${size})`);
}
