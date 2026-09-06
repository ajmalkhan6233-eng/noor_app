// Draws the "glossy 3D orb" motif shared with the in-app bottom-nav
// badges (lib/core/presentation/icons/noor_icon_style.dart:
// paintNavOrbBadge) — a radial-gradient obsidian sphere, a cyan rim,
// a soft specular highlight, and the brand gold crescent glyph.
// Reproduced here in raw pixel math since no canvas dependency is
// available in this environment (see .claude/skills/noor-icon-generation).
const { edgeCoverage, lerpColor, over } = require('./icon_gfx');

const SPHERE_LIGHT = [0x1b, 0x27, 0x32];
const SPHERE_DARK = [0x0a, 0x12, 0x19];
const CYAN = [0x00, 0xf2, 0xfe];
const GOLD = [0xff, 0xb7, 0x03];

/// Renders an RGBA buffer of `size`x`size`. `sphereRadius` is the outer
/// radius of the drawn sphere in pixels; `drawSphereFill` controls
/// whether the gradient body itself is painted (false = crescent/ring/
/// highlight only, transparent elsewhere — used for the adaptive-icon
/// foreground layer, which sits on its own background layer).
function drawOrb(size, sphereRadius, { drawSphereFill = true, rimAlpha = 0.85 } = {}) {
  const px = Buffer.alloc(size * size * 4);
  const cx = size / 2;
  const cy = size / 2;
  const R = sphereRadius;
  const aa = Math.max(0.75, size * 0.006);

  const ringWidth = R * 0.075;
  const ringOuter = R * 0.98;
  const ringInner = ringOuter - ringWidth;

  const moonR = R * 0.62;
  const moonCx = cx;
  const moonCy = cy;
  const cutCx = moonCx + moonR * 0.55;
  const cutCy = moonCy - moonR * 0.12;
  const cutR = moonR * 0.92;

  // Gradient center offset up-left, per paintNavOrbBadge's Alignment(-0.35, -0.45).
  const gradCx = cx - 0.35 * R;
  const gradCy = cy - 0.45 * R;
  const gradR = 0.95 * R;

  // Specular highlight: soft white ellipse, upper-left of the sphere.
  const hlCx = cx - 0.18 * R;
  const hlCy = cy - 0.42 * R;
  const hlRx = 0.34 * R;
  const hlRy = 0.20 * R;

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const px_ = x + 0.5;
      const py_ = y + 0.5;
      const dx = px_ - cx;
      const dy = py_ - cy;
      const dist = Math.sqrt(dx * dx + dy * dy);
      const sphereCoverage = edgeCoverage(dist, R, aa);
      if (sphereCoverage <= 0) continue;

      let rgb = [0, 0, 0];
      let alpha = 0;

      if (drawSphereFill) {
        const gdx = px_ - gradCx;
        const gdy = py_ - gradCy;
        const gdist = Math.sqrt(gdx * gdx + gdy * gdy);
        rgb = lerpColor(SPHERE_LIGHT, SPHERE_DARK, gdist / gradR);
        alpha = 1;
      }

      // Gold crescent glyph.
      const mdist = Math.sqrt((px_ - moonCx) ** 2 + (py_ - moonCy) ** 2);
      if (mdist < moonR + aa) {
        const moonCoverage = edgeCoverage(mdist, moonR, aa);
        const cutDist = Math.sqrt((px_ - cutCx) ** 2 + (py_ - cutCy) ** 2);
        const cutCoverage = 1 - edgeCoverage(cutDist, cutR, aa); // 1 = outside the cut (visible gold)
        const glyphAlpha = moonCoverage * cutCoverage;
        if (glyphAlpha > 0) {
          rgb = over(rgb, GOLD, glyphAlpha * (alpha > 0 ? 1 : 1));
          alpha = Math.max(alpha, glyphAlpha);
        }
      }

      // Cyan rim band near the outer edge.
      const ringCov = edgeCoverage(dist, ringOuter, aa) * (1 - edgeCoverage(dist, ringInner, aa));
      if (ringCov > 0) {
        rgb = over(rgb, CYAN, ringCov * rimAlpha);
        alpha = Math.max(alpha, ringCov * rimAlpha);
      }

      // Specular highlight — glosses whatever's already drawn (sphere
      // fill when present, or just leaves a soft glow on transparent
      // when this layer is ring/crescent-only, e.g. adaptive foreground).
      const nx = (px_ - hlCx) / hlRx;
      const ny = (py_ - hlCy) / hlRy;
      const hlDist = Math.sqrt(nx * nx + ny * ny);
      if (hlDist < 1) {
        const hlAlpha = (1 - hlDist) * (drawSphereFill ? 0.32 : 0.22);
        rgb = over(rgb, [255, 255, 255], hlAlpha);
        alpha = Math.max(alpha, hlAlpha);
      }

      const finalAlpha = Math.round(alpha * sphereCoverage * 255);
      const idx = (y * size + x) * 4;
      px[idx] = Math.round(rgb[0]);
      px[idx + 1] = Math.round(rgb[1]);
      px[idx + 2] = Math.round(rgb[2]);
      px[idx + 3] = finalAlpha;
    }
  }
  return px;
}

/// Full-canvas version of the sphere gradient with no circular clip and
/// no ring/crescent/highlight — used as the adaptive-icon background
/// layer, which is masked into shape by the launcher itself, so it
/// needs to fill every corner of the square.
function drawBackgroundGradient(size) {
  const px = Buffer.alloc(size * size * 4);
  const cx = size / 2;
  const cy = size / 2;
  const gradCx = cx - 0.35 * size * 0.5;
  const gradCy = cy - 0.45 * size * 0.5;
  const gradR = 0.95 * size * 0.5;

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const dx = x + 0.5 - gradCx;
      const dy = y + 0.5 - gradCy;
      const dist = Math.sqrt(dx * dx + dy * dy);
      const rgb = lerpColor(SPHERE_LIGHT, SPHERE_DARK, dist / gradR);
      const idx = (y * size + x) * 4;
      px[idx] = Math.round(rgb[0]);
      px[idx + 1] = Math.round(rgb[1]);
      px[idx + 2] = Math.round(rgb[2]);
      px[idx + 3] = 255;
    }
  }
  return px;
}

module.exports = { drawOrb, drawBackgroundGradient };
