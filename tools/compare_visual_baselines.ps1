param(
    [string]$ReferenceCommit = 'd78a50d'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$projectRoot = Split-Path -Parent $PSScriptRoot
$referenceRoot = Join-Path $projectRoot "docs\product\baselines\lovable\$ReferenceCommit"
$targetRoot = Join-Path $projectRoot 'apps\mobile\test\goldens\parity'
$outputRoot = Join-Path $projectRoot "docs\product\comparisons\$ReferenceCommit"

$viewports = @('360x800', '390x844', '440x900')

foreach ($viewport in $viewports) {
    $parts = $viewport.Split('x')
    $width = [int]$parts[0]
    $height = [int]$parts[1]
    $referenceDirectory = Join-Path $referenceRoot $viewport
    $targetDirectory = Join-Path $targetRoot $viewport
    $outputDirectory = Join-Path $outputRoot $viewport
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null

    foreach ($referenceFile in Get-ChildItem -LiteralPath $referenceDirectory -Filter '*.png') {
        $targetFile = Join-Path $targetDirectory $referenceFile.Name
        if (-not (Test-Path -LiteralPath $targetFile)) {
            Write-Warning "Sem baseline Flutter para $viewport/$($referenceFile.Name)"
            continue
        }

        $reference = [System.Drawing.Bitmap]::FromFile($referenceFile.FullName)
        $target = [System.Drawing.Bitmap]::FromFile($targetFile)
        $normalizedReference = [System.Drawing.Bitmap]::new($width, $height)
        $referenceGraphics = [System.Drawing.Graphics]::FromImage($normalizedReference)
        $referenceGraphics.Clear([System.Drawing.Color]::White)
        $referenceGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $stem = [System.IO.Path]::GetFileNameWithoutExtension($referenceFile.Name)
        $scaledViewportHeight = [int][Math]::Ceiling($height * $reference.Width / $width)
        $hasDetachedNavigation =
            $stem -ne 'onboarding' -and
            $reference.Height -gt [int]($scaledViewportHeight * 1.2)
        if ($hasDetachedNavigation) {
            $navigationHeight = 68
            $sourceNavigationHeight = [int][Math]::Ceiling(
                $navigationHeight * $reference.Width / $width
            )
            $bodyHeight = $height - $navigationHeight
            $sourceBodyHeight = [int][Math]::Ceiling(
                $bodyHeight * $reference.Width / $width
            )
            $referenceGraphics.DrawImage(
                $reference,
                [System.Drawing.Rectangle]::new(0, 0, $width, $bodyHeight),
                [System.Drawing.Rectangle]::new(0, 0, $reference.Width, $sourceBodyHeight),
                [System.Drawing.GraphicsUnit]::Pixel
            )
            $referenceGraphics.DrawImage(
                $reference,
                [System.Drawing.Rectangle]::new(0, $bodyHeight, $width, $navigationHeight),
                [System.Drawing.Rectangle]::new(
                    0,
                    ($reference.Height - $sourceNavigationHeight),
                    $reference.Width,
                    $sourceNavigationHeight
                ),
                [System.Drawing.GraphicsUnit]::Pixel
            )
        }
        else {
            $sourceHeight = [Math]::Min($reference.Height, $scaledViewportHeight)
            $referenceGraphics.DrawImage(
                $reference,
                [System.Drawing.Rectangle]::new(0, 0, $width, $height),
                [System.Drawing.Rectangle]::new(0, 0, $reference.Width, $sourceHeight),
                [System.Drawing.GraphicsUnit]::Pixel
            )
        }
        $referenceGraphics.Dispose()

        $sideBySide = [System.Drawing.Bitmap]::new(($width * 2), $height)
        $sideGraphics = [System.Drawing.Graphics]::FromImage($sideBySide)
        $sideGraphics.Clear([System.Drawing.Color]::White)
        $sideGraphics.DrawImageUnscaled($normalizedReference, 0, 0)
        $sideGraphics.DrawImage(
            $target,
            [System.Drawing.Rectangle]::new($width, 0, $width, $height)
        )
        $sideGraphics.Dispose()

        $overlay = [System.Drawing.Bitmap]::new($width, $height)
        $overlayGraphics = [System.Drawing.Graphics]::FromImage($overlay)
        $overlayGraphics.DrawImageUnscaled($normalizedReference, 0, 0)
        $attributes = [System.Drawing.Imaging.ImageAttributes]::new()
        $matrix = [System.Drawing.Imaging.ColorMatrix]::new()
        $matrix.Matrix33 = 0.5
        $attributes.SetColorMatrix($matrix)
        $overlayGraphics.DrawImage(
            $target,
            [System.Drawing.Rectangle]::new(0, 0, $width, $height),
            0,
            0,
            $target.Width,
            $target.Height,
            [System.Drawing.GraphicsUnit]::Pixel,
            $attributes
        )
        $attributes.Dispose()
        $overlayGraphics.Dispose()

        $sidePath = Join-Path $outputDirectory "${stem}_side-by-side.png"
        $overlayPath = Join-Path $outputDirectory "${stem}_overlay.png"
        $sideBySide.Save($sidePath, [System.Drawing.Imaging.ImageFormat]::Png)
        $overlay.Save($overlayPath, [System.Drawing.Imaging.ImageFormat]::Png)

        $overlay.Dispose()
        $sideBySide.Dispose()
        $normalizedReference.Dispose()
        $target.Dispose()
        $reference.Dispose()
    }
}

Write-Output "Comparações gravadas em $outputRoot"
