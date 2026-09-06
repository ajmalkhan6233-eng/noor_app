# Derives every app-icon asset (Android legacy launcher, Android
# adaptive-icon layers, web favicon/PWA icons) from the real master
# artwork Aj supplied (design/noor_icon_master.png — Arabic "noor"
# calligraphy, star sparkles, obsidian-to-navy gradient, rounded-square
# with a soft drop shadow already baked in). This replaces the
# code-drawn crescent/cyan-ring placeholder used earlier tonight.
# Master lives in the repo (not Downloads) so this script is
# reproducible on any machine/CI, not just the one it was drawn on.
#
# Run: powershell -File scripts\gen_icons_from_master.ps1

Add-Type -AssemblyName System.Drawing

$repoRoot = Split-Path -Parent $PSScriptRoot
$masterPath = Join-Path $repoRoot "design\noor_icon_master.png"
$master = [System.Drawing.Image]::FromFile($masterPath)

function New-ResizedPng {
    param(
        [string]$OutPath,
        [int]$Size,
        [double]$ContentScale = 1.0,   # 1.0 = full bleed; <1.0 leaves a safe-zone margin
        [System.Drawing.Color]$FillColor = [System.Drawing.Color]::Transparent
    )
    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    $bmp.SetResolution($master.HorizontalResolution, $master.VerticalResolution)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    if ($FillColor -ne [System.Drawing.Color]::Transparent) {
        $g.Clear($FillColor)
    }
    $drawSize = [int]([Math]::Round($Size * $ContentScale))
    $offset = [int]([Math]::Round(($Size - $drawSize) / 2))
    $g.DrawImage($master, $offset, $offset, $drawSize, $drawSize)
    $g.Dispose()
    $dir = Split-Path -Parent $OutPath
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    $bmp.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Wrote $OutPath ($Size x $Size, scale=$ContentScale)"
}

function New-TransparentPng {
    param([string]$OutPath, [int]$Size)
    $bmp = New-Object System.Drawing.Bitmap $Size, $Size
    $bmp.Save($OutPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Output "Wrote $OutPath ($Size x $Size, blank/transparent)"
}

# Sample a corner-ish background tone from the master (near a corner,
# just inside the rounded-corner radius) to fill the padding ring on
# maskable icons so it blends rather than showing a hard edge.
$bmpSample = New-Object System.Drawing.Bitmap ($masterPath)
$edgeColor = $bmpSample.GetPixel([int]($bmpSample.Width * 0.5), [int]($bmpSample.Height * 0.03))
$bmpSample.Dispose()
Write-Output "Sampled edge color for maskable padding: $edgeColor"

# --- Android legacy flat launcher icon (pre-26 fallback) ---
$legacyDensities = @{ 'mipmap-mdpi' = 48; 'mipmap-hdpi' = 72; 'mipmap-xhdpi' = 96; 'mipmap-xxhdpi' = 144; 'mipmap-xxxhdpi' = 192 }
foreach ($dir in $legacyDensities.Keys) {
    $size = $legacyDensities[$dir]
    New-ResizedPng -OutPath (Join-Path $repoRoot "android\app\src\main\res\$dir\ic_launcher.png") -Size $size -ContentScale 1.0
}

# --- Android adaptive icon (API 26+, also what the system splash uses) ---
# Background = the full master image (it already fills its own canvas
# edge to edge under the rounded corners); foreground = blank, since
# the artwork is one flat composition, not separable layers.
$adaptiveDensities = @{ 'mipmap-mdpi' = 108; 'mipmap-hdpi' = 162; 'mipmap-xhdpi' = 216; 'mipmap-xxhdpi' = 324; 'mipmap-xxxhdpi' = 432 }
foreach ($dir in $adaptiveDensities.Keys) {
    $size = $adaptiveDensities[$dir]
    New-ResizedPng -OutPath (Join-Path $repoRoot "android\app\src\main\res\$dir\ic_launcher_background.png") -Size $size -ContentScale 1.0
    New-TransparentPng -OutPath (Join-Path $repoRoot "android\app\src\main\res\$dir\ic_launcher_foreground.png") -Size $size
}

# --- Web favicon + PWA icons ---
New-ResizedPng -OutPath (Join-Path $repoRoot "web\favicon.png") -Size 32 -ContentScale 1.0
New-ResizedPng -OutPath (Join-Path $repoRoot "web\icons\Icon-192.png") -Size 192 -ContentScale 1.0
New-ResizedPng -OutPath (Join-Path $repoRoot "web\icons\Icon-512.png") -Size 512 -ContentScale 1.0
# Maskable: leave a safe-zone margin (installers may crop to circle/squircle).
New-ResizedPng -OutPath (Join-Path $repoRoot "web\icons\Icon-maskable-192.png") -Size 192 -ContentScale 0.72 -FillColor $edgeColor
New-ResizedPng -OutPath (Join-Path $repoRoot "web\icons\Icon-maskable-512.png") -Size 512 -ContentScale 0.72 -FillColor $edgeColor

$master.Dispose()
Write-Output "Done."
