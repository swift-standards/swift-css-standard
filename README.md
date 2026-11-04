# swift-css-standard

Use this package when you want the W3C CSS vocabulary behind one import, and need to move CSS color values to and from sRGB. Start from `W3C_CSS_Values.Color` and its `W3C_CSS_Values.Color.sRGB` form. If you only need some CSS modules and no color conversion, depend on swift-w3c-css directly.

## Laws

- Converting a CSS color to sRGB drops its alpha. rgba(), hsla() and four or eight digit hex give the same channels as their opaque forms.
- currentColor, transparent, system colors, color-mix() and named colors without a fixed sRGB value have no sRGB form, and the conversion returns nil.
- Hex may be written with or without the leading #. Three and four digit hex expand each digit, so #f80 is #ff8800.
- Hex that isn't valid becomes black. No error is reported.
- HSL and HWB take their hue in degrees, normalized, and their other components as percentages.
- lab(), lch(), oklab() and oklch() colors are converted through swift-color-standard, so lightness is clamped to its range there.
- An sRGB color written back to CSS is always rgb(), with each channel rounded to the nearest of 0 through 255. A NaN channel becomes 0 and a channel above 1 becomes 255.
