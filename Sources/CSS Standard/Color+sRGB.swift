// Color+sRGB.swift
// CSS Standard ↔ IEC 61966-2-1 sRGB conversions
//
// This file bridges W3C CSS Color values with IEC 61966-2-1 sRGB,
// the standard color space that CSS rgb() operates in.

public import IEC_61966
import RFC_4648
public import W3C_CSS_Values

// MARK: - sRGB from CSS Color

extension IEC_61966.`2`.`1`.sRGB {
    /// Create sRGB from CSS Color value
    ///
    /// Converts CSS color representations to IEC 61966-2-1 sRGB.
    ///
    /// - Parameter color: A CSS color value
    ///
    /// ## Supported Conversions
    ///
    /// - `.rgb(Int, Int, Int)` - Direct conversion (values / 255)
    /// - `.rgba(Int, Int, Int, Double)` - RGB conversion (alpha ignored)
    /// - `.hsl(Hue, Double, Double)` - HSL to RGB conversion
    /// - `.hsla(Hue, Double, Double, Double)` - HSL to RGB (alpha ignored)
    /// - `.hwb(Hue, Double, Double)` - HWB to RGB conversion
    /// - `.hex(HexColor)` - Hex to RGB conversion
    /// - `.named(NamedColor)` - Named color to RGB conversion
    ///
    /// ## Reference
    ///
    /// - CSS Color Level 4: https://www.w3.org/TR/css-color-4/
    /// - IEC 61966-2-1:1999 — sRGB standard
    public init?(_ color: W3C_CSS_Values.Color) {
        switch color {
        case .rgb(let r, let g, let b):
            self.init(
                r: Double(r) / 255.0,
                g: Double(g) / 255.0,
                b: Double(b) / 255.0
            )

        case .rgba(let r, let g, let b, _):
            self.init(
                r: Double(r) / 255.0,
                g: Double(g) / 255.0,
                b: Double(b) / 255.0
            )

        case .hsl(let h, let s, let l):
            // CSS uses 0-100 for saturation/lightness percentages
            self.init(h: h.normalizedDegrees(), s: s / 100.0, l: l / 100.0)

        case .hsla(let h, let s, let l, _):
            self.init(h: h.normalizedDegrees(), s: s / 100.0, l: l / 100.0)

        case .hwb(let h, let w, let b):
            // CSS uses 0-100 for whiteness/blackness percentages
            self.init(hue: h.normalizedDegrees(), whiteness: w / 100.0, blackness: b / 100.0)

        case .hex(let hex):
            self.init(hex)

        case .named(let named):
            if let srgb = Self(named) {
                self = srgb
            } else {
                return nil
            }

        case .lab, .lch, .oklab, .oklch, .mix, .system, .currentColor, .transparent:
            // These require more complex color space conversions
            return nil
        }
    }

    /// Create sRGB from CSS HexColor using RFC 4648 Base16 decoding
    ///
    /// - Parameter hex: A CSS hex color value
    ///
    /// ## Supported Formats
    ///
    /// - `#RGB` - Shorthand (expands to #RRGGBB)
    /// - `#RGBA` - Shorthand with alpha (expands to #RRGGBBAA)
    /// - `#RRGGBB` - Standard 6-digit hex
    /// - `#RRGGBBAA` - 8-digit hex with alpha
    ///
    /// ## Reference
    ///
    /// - RFC 4648 Section 8: Base16 Encoding
    /// - CSS Color Level 4: Hexadecimal notation
    public init(_ hex: W3C_CSS_Values.HexColor) {
        let value =
            hex.value.hasPrefix("#")
            ? String(hex.value.dropFirst())
            : hex.value

        // Expand shorthand notation (#RGB → #RRGGBB, #RGBA → #RRGGBBAA)
        let expanded: String
        switch value.count {
        case 3:  // RGB shorthand
            let chars = Array(value)
            expanded = "\(chars[0])\(chars[0])\(chars[1])\(chars[1])\(chars[2])\(chars[2])"
        case 4:  // RGBA shorthand
            let chars = Array(value)
            expanded =
                "\(chars[0])\(chars[0])\(chars[1])\(chars[1])\(chars[2])\(chars[2])\(chars[3])\(chars[3])"
        default:
            expanded = value
        }

        // Decode using RFC 4648 Base16
        guard let bytes = [UInt8](hexEncoded: expanded), bytes.count >= 3 else {
            self.init(r: 0, g: 0, b: 0)
            return
        }

        self.init(
            r: Double(bytes[0]) / 255.0,
            g: Double(bytes[1]) / 255.0,
            b: Double(bytes[2]) / 255.0
        )
    }

    /// Create sRGB from CSS NamedColor
    ///
    /// - Parameter named: A CSS named color
    /// - Returns: nil for currentColor and transparent (context-dependent)
    ///
    /// This initializer delegates to `NamedColor.sRGB` which provides
    /// the W3C CSS Color Level 4 standardized RGB values.
    public init?(_ named: W3C_CSS_Values.NamedColor) {
        guard let srgb = named.sRGB else { return nil }
        self = srgb
    }
}

// MARK: - CSS Color from sRGB

extension W3C_CSS_Values.Color {
    /// Create CSS Color from IEC 61966-2-1 sRGB
    ///
    /// Converts an sRGB color to CSS rgb() notation.
    ///
    /// - Parameter srgb: An sRGB color
    ///
    /// ## Reference
    ///
    /// - CSS Color Level 4: https://www.w3.org/TR/css-color-4/
    /// - IEC 61966-2-1:1999 — sRGB standard
    public init(_ srgb: IEC_61966.`2`.`1`.sRGB) {
        self = .rgb(
            Int((srgb.r * 255).rounded()),
            Int((srgb.g * 255).rounded()),
            Int((srgb.b * 255).rounded())
        )
    }

    /// Create CSS Color from HSL using IEC 61966 validated types
    ///
    /// - Parameters:
    ///   - hue: Hue angle (auto-normalizes to 0-360°)
    ///   - saturation: Saturation component (0-1, validated)
    ///   - lightness: Lightness component (0-1, validated)
    public static func hsl(
        hue: IEC_61966.`2`.`1`.Hue,
        saturation: IEC_61966.`2`.`1`.Saturation,
        lightness: IEC_61966.`2`.`1`.Lightness
    ) -> Color {
        // Convert from IEC 61966 0-1 range to CSS 0-100 percentage
        .hsl(
            .number(.init(hue.degrees)),
            saturation.value * 100,
            lightness.value * 100
        )
    }

    /// Create CSS Color from HWB using IEC 61966 validated types
    ///
    /// - Parameters:
    ///   - hue: Hue angle (auto-normalizes to 0-360°)
    ///   - whiteness: Whiteness component (0-1, validated)
    ///   - blackness: Blackness component (0-1, validated)
    public static func hwb(
        hue: IEC_61966.`2`.`1`.Hue,
        whiteness: IEC_61966.`2`.`1`.Whiteness,
        blackness: IEC_61966.`2`.`1`.Blackness
    ) -> Color {
        // Convert from IEC 61966 0-1 range to CSS 0-100 percentage
        .hwb(
            .number(.init(hue.degrees)),
            whiteness.value * 100,
            blackness.value * 100
        )
    }
}

// MARK: - Convenience Type Aliases

extension W3C_CSS_Values.Color {
    /// sRGB type from IEC 61966-2-1
    public typealias sRGB = IEC_61966.`2`.`1`.sRGB
}
