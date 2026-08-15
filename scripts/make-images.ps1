# OGP画像 / favicon 一式を生成するスクリプト（ローカル描画のみ・外部通信なし）
# 実行: powershell -ExecutionPolicy Bypass -File scripts\make-images.ps1
Add-Type -AssemblyName System.Drawing

$pub = Join-Path $PSScriptRoot '..\public'
$pub = (Resolve-Path $pub).Path

# ---------- OGP 1200x630 ----------
$bmp = New-Object System.Drawing.Bitmap 1200, 630
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = 'AntiAlias'
$g.TextRenderingHint = 'ClearTypeGridFit'

$rect = New-Object System.Drawing.Rectangle 0, 0, 1200, 630
$bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, [System.Drawing.Color]::FromArgb(18, 41, 74), [System.Drawing.Color]::FromArgb(43, 108, 176), 20)
$g.FillRectangle($bg, $rect)

$glow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(38, 99, 179, 237))
$g.FillEllipse($glow, 820, -150, 540, 540)
$g.FillEllipse($glow, -130, 370, 440, 440)

$accent = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 99, 179, 237))
$g.FillRectangle($accent, 90, 118, 96, 6)

$fLabel = New-Object System.Drawing.Font 'Yu Gothic UI', 19, ([System.Drawing.FontStyle]::Bold)
$fTitle = New-Object System.Drawing.Font 'Yu Gothic UI', 50, ([System.Drawing.FontStyle]::Bold)
$fSub = New-Object System.Drawing.Font 'Yu Gothic UI', 20
$fName = New-Object System.Drawing.Font 'Yu Gothic UI', 21, ([System.Drawing.FontStyle]::Bold)

$white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
$light = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(225, 190, 227, 248))

$g.DrawString('AI BUSINESS AUTOMATION', $fLabel, $accent, 88, 148)
$g.DrawString('業務の無駄を削ぎ落とし、', $fTitle, $white, 80, 214)
$g.DrawString('AIが働く仕組みをつくる。', $fTitle, $white, 80, 296)
$g.DrawString('Claude Code × AWS で、御社の生産性を変える', $fSub, $light, 88, 404)
$g.DrawString('AI業務自動化支援 ｜ 福田 和弘', $fName, $white, 88, 486)

$bmp.Save((Join-Path $pub 'ogp.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()

# ---------- favicon / app icons ----------
function New-BrandIcon {
    param([int]$Size, [string]$Path)
    $b = New-Object System.Drawing.Bitmap $Size, $Size
    $gg = [System.Drawing.Graphics]::FromImage($b)
    $gg.SmoothingMode = 'AntiAlias'
    $gg.TextRenderingHint = 'AntiAlias'
    $r = New-Object System.Drawing.Rectangle 0, 0, $Size, $Size
    $br = New-Object System.Drawing.Drawing2D.LinearGradientBrush($r, [System.Drawing.Color]::FromArgb(18, 41, 74), [System.Drawing.Color]::FromArgb(99, 179, 237), 45)
    $gg.FillRectangle($br, $r)
    $fs = [int]($Size * 0.62)
    $f = New-Object System.Drawing.Font 'Yu Gothic UI', $fs, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = 'Center'
    $sf.LineAlignment = 'Center'
    $box = New-Object System.Drawing.RectangleF 0, 0, $Size, $Size
    $gg.DrawString('F', $f, [System.Drawing.Brushes]::White, $box, $sf)
    $b.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $gg.Dispose()
    $b.Dispose()
}

New-BrandIcon -Size 32 -Path (Join-Path $pub 'favicon-32.png')
New-BrandIcon -Size 192 -Path (Join-Path $pub 'icon-192.png')
New-BrandIcon -Size 180 -Path (Join-Path $pub 'apple-touch-icon.png')

Write-Output 'generated: ogp.png / favicon-32.png / icon-192.png / apple-touch-icon.png'
