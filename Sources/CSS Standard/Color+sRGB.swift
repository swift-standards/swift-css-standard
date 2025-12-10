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
    public init?(_ named: W3C_CSS_Values.NamedColor) {
        // Named colors map to specific sRGB values per CSS Color Level 4
        switch named {
        case .aliceblue: self.init(r: 240 / 255, g: 248 / 255, b: 255 / 255)
        case .antiquewhite: self.init(r: 250 / 255, g: 235 / 255, b: 215 / 255)
        case .aqua: self.init(r: 0, g: 255 / 255, b: 255 / 255)
        case .aquamarine: self.init(r: 127 / 255, g: 255 / 255, b: 212 / 255)
        case .azure: self.init(r: 240 / 255, g: 255 / 255, b: 255 / 255)
        case .beige: self.init(r: 245 / 255, g: 245 / 255, b: 220 / 255)
        case .bisque: self.init(r: 255 / 255, g: 228 / 255, b: 196 / 255)
        case .black: self.init(r: 0, g: 0, b: 0)
        case .blanchedalmond: self.init(r: 255 / 255, g: 235 / 255, b: 205 / 255)
        case .blue: self.init(r: 0, g: 0, b: 255 / 255)
        case .blueviolet: self.init(r: 138 / 255, g: 43 / 255, b: 226 / 255)
        case .brown: self.init(r: 165 / 255, g: 42 / 255, b: 42 / 255)
        case .burlywood: self.init(r: 222 / 255, g: 184 / 255, b: 135 / 255)
        case .cadetblue: self.init(r: 95 / 255, g: 158 / 255, b: 160 / 255)
        case .chartreuse: self.init(r: 127 / 255, g: 255 / 255, b: 0)
        case .chocolate: self.init(r: 210 / 255, g: 105 / 255, b: 30 / 255)
        case .coral: self.init(r: 255 / 255, g: 127 / 255, b: 80 / 255)
        case .cornflowerblue: self.init(r: 100 / 255, g: 149 / 255, b: 237 / 255)
        case .cornsilk: self.init(r: 255 / 255, g: 248 / 255, b: 220 / 255)
        case .crimson: self.init(r: 220 / 255, g: 20 / 255, b: 60 / 255)
        case .cyan: self.init(r: 0, g: 255 / 255, b: 255 / 255)
        case .darkblue: self.init(r: 0, g: 0, b: 139 / 255)
        case .darkcyan: self.init(r: 0, g: 139 / 255, b: 139 / 255)
        case .darkgoldenrod: self.init(r: 184 / 255, g: 134 / 255, b: 11 / 255)
        case .darkgray: self.init(r: 169 / 255, g: 169 / 255, b: 169 / 255)
        case .darkgreen: self.init(r: 0, g: 100 / 255, b: 0)
        case .darkgrey: self.init(r: 169 / 255, g: 169 / 255, b: 169 / 255)
        case .darkkhaki: self.init(r: 189 / 255, g: 183 / 255, b: 107 / 255)
        case .darkmagenta: self.init(r: 139 / 255, g: 0, b: 139 / 255)
        case .darkolivegreen: self.init(r: 85 / 255, g: 107 / 255, b: 47 / 255)
        case .darkorange: self.init(r: 255 / 255, g: 140 / 255, b: 0)
        case .darkorchid: self.init(r: 153 / 255, g: 50 / 255, b: 204 / 255)
        case .darkred: self.init(r: 139 / 255, g: 0, b: 0)
        case .darksalmon: self.init(r: 233 / 255, g: 150 / 255, b: 122 / 255)
        case .darkseagreen: self.init(r: 143 / 255, g: 188 / 255, b: 143 / 255)
        case .darkslateblue: self.init(r: 72 / 255, g: 61 / 255, b: 139 / 255)
        case .darkslategray: self.init(r: 47 / 255, g: 79 / 255, b: 79 / 255)
        case .darkslategrey: self.init(r: 47 / 255, g: 79 / 255, b: 79 / 255)
        case .darkturquoise: self.init(r: 0, g: 206 / 255, b: 209 / 255)
        case .darkviolet: self.init(r: 148 / 255, g: 0, b: 211 / 255)
        case .deeppink: self.init(r: 255 / 255, g: 20 / 255, b: 147 / 255)
        case .deepskyblue: self.init(r: 0, g: 191 / 255, b: 255 / 255)
        case .dimgray: self.init(r: 105 / 255, g: 105 / 255, b: 105 / 255)
        case .dimgrey: self.init(r: 105 / 255, g: 105 / 255, b: 105 / 255)
        case .dodgerblue: self.init(r: 30 / 255, g: 144 / 255, b: 255 / 255)
        case .firebrick: self.init(r: 178 / 255, g: 34 / 255, b: 34 / 255)
        case .floralwhite: self.init(r: 255 / 255, g: 250 / 255, b: 240 / 255)
        case .forestgreen: self.init(r: 34 / 255, g: 139 / 255, b: 34 / 255)
        case .fuchsia: self.init(r: 255 / 255, g: 0, b: 255 / 255)
        case .gainsboro: self.init(r: 220 / 255, g: 220 / 255, b: 220 / 255)
        case .ghostwhite: self.init(r: 248 / 255, g: 248 / 255, b: 255 / 255)
        case .gold: self.init(r: 255 / 255, g: 215 / 255, b: 0)
        case .goldenrod: self.init(r: 218 / 255, g: 165 / 255, b: 32 / 255)
        case .gray: self.init(r: 128 / 255, g: 128 / 255, b: 128 / 255)
        case .green: self.init(r: 0, g: 128 / 255, b: 0)
        case .greenyellow: self.init(r: 173 / 255, g: 255 / 255, b: 47 / 255)
        case .grey: self.init(r: 128 / 255, g: 128 / 255, b: 128 / 255)
        case .honeydew: self.init(r: 240 / 255, g: 255 / 255, b: 240 / 255)
        case .hotpink: self.init(r: 255 / 255, g: 105 / 255, b: 180 / 255)
        case .indianred: self.init(r: 205 / 255, g: 92 / 255, b: 92 / 255)
        case .indigo: self.init(r: 75 / 255, g: 0, b: 130 / 255)
        case .ivory: self.init(r: 255 / 255, g: 255 / 255, b: 240 / 255)
        case .khaki: self.init(r: 240 / 255, g: 230 / 255, b: 140 / 255)
        case .lavender: self.init(r: 230 / 255, g: 230 / 255, b: 250 / 255)
        case .lavenderblush: self.init(r: 255 / 255, g: 240 / 255, b: 245 / 255)
        case .lawngreen: self.init(r: 124 / 255, g: 252 / 255, b: 0)
        case .lemonchiffon: self.init(r: 255 / 255, g: 250 / 255, b: 205 / 255)
        case .lightblue: self.init(r: 173 / 255, g: 216 / 255, b: 230 / 255)
        case .lightcoral: self.init(r: 240 / 255, g: 128 / 255, b: 128 / 255)
        case .lightcyan: self.init(r: 224 / 255, g: 255 / 255, b: 255 / 255)
        case .lightgoldenrodyellow: self.init(r: 250 / 255, g: 250 / 255, b: 210 / 255)
        case .lightgray: self.init(r: 211 / 255, g: 211 / 255, b: 211 / 255)
        case .lightgreen: self.init(r: 144 / 255, g: 238 / 255, b: 144 / 255)
        case .lightgrey: self.init(r: 211 / 255, g: 211 / 255, b: 211 / 255)
        case .lightpink: self.init(r: 255 / 255, g: 182 / 255, b: 193 / 255)
        case .lightsalmon: self.init(r: 255 / 255, g: 160 / 255, b: 122 / 255)
        case .lightseagreen: self.init(r: 32 / 255, g: 178 / 255, b: 170 / 255)
        case .lightskyblue: self.init(r: 135 / 255, g: 206 / 255, b: 250 / 255)
        case .lightslategray: self.init(r: 119 / 255, g: 136 / 255, b: 153 / 255)
        case .lightslategrey: self.init(r: 119 / 255, g: 136 / 255, b: 153 / 255)
        case .lightsteelblue: self.init(r: 176 / 255, g: 196 / 255, b: 222 / 255)
        case .lightyellow: self.init(r: 255 / 255, g: 255 / 255, b: 224 / 255)
        case .lime: self.init(r: 0, g: 255 / 255, b: 0)
        case .limegreen: self.init(r: 50 / 255, g: 205 / 255, b: 50 / 255)
        case .linen: self.init(r: 250 / 255, g: 240 / 255, b: 230 / 255)
        case .magenta: self.init(r: 255 / 255, g: 0, b: 255 / 255)
        case .maroon: self.init(r: 128 / 255, g: 0, b: 0)
        case .mediumaquamarine: self.init(r: 102 / 255, g: 205 / 255, b: 170 / 255)
        case .mediumblue: self.init(r: 0, g: 0, b: 205 / 255)
        case .mediumorchid: self.init(r: 186 / 255, g: 85 / 255, b: 211 / 255)
        case .mediumpurple: self.init(r: 147 / 255, g: 112 / 255, b: 219 / 255)
        case .mediumseagreen: self.init(r: 60 / 255, g: 179 / 255, b: 113 / 255)
        case .mediumslateblue: self.init(r: 123 / 255, g: 104 / 255, b: 238 / 255)
        case .mediumspringgreen: self.init(r: 0, g: 250 / 255, b: 154 / 255)
        case .mediumturquoise: self.init(r: 72 / 255, g: 209 / 255, b: 204 / 255)
        case .mediumvioletred: self.init(r: 199 / 255, g: 21 / 255, b: 133 / 255)
        case .midnightblue: self.init(r: 25 / 255, g: 25 / 255, b: 112 / 255)
        case .mintcream: self.init(r: 245 / 255, g: 255 / 255, b: 250 / 255)
        case .mistyrose: self.init(r: 255 / 255, g: 228 / 255, b: 225 / 255)
        case .moccasin: self.init(r: 255 / 255, g: 228 / 255, b: 181 / 255)
        case .navajowhite: self.init(r: 255 / 255, g: 222 / 255, b: 173 / 255)
        case .navy: self.init(r: 0, g: 0, b: 128 / 255)
        case .oldlace: self.init(r: 253 / 255, g: 245 / 255, b: 230 / 255)
        case .olive: self.init(r: 128 / 255, g: 128 / 255, b: 0)
        case .olivedrab: self.init(r: 107 / 255, g: 142 / 255, b: 35 / 255)
        case .orange: self.init(r: 255 / 255, g: 165 / 255, b: 0)
        case .orangered: self.init(r: 255 / 255, g: 69 / 255, b: 0)
        case .orchid: self.init(r: 218 / 255, g: 112 / 255, b: 214 / 255)
        case .palegoldenrod: self.init(r: 238 / 255, g: 232 / 255, b: 170 / 255)
        case .palegreen: self.init(r: 152 / 255, g: 251 / 255, b: 152 / 255)
        case .paleturquoise: self.init(r: 175 / 255, g: 238 / 255, b: 238 / 255)
        case .palevioletred: self.init(r: 219 / 255, g: 112 / 255, b: 147 / 255)
        case .papayawhip: self.init(r: 255 / 255, g: 239 / 255, b: 213 / 255)
        case .peachpuff: self.init(r: 255 / 255, g: 218 / 255, b: 185 / 255)
        case .peru: self.init(r: 205 / 255, g: 133 / 255, b: 63 / 255)
        case .pink: self.init(r: 255 / 255, g: 192 / 255, b: 203 / 255)
        case .plum: self.init(r: 221 / 255, g: 160 / 255, b: 221 / 255)
        case .powderblue: self.init(r: 176 / 255, g: 224 / 255, b: 230 / 255)
        case .purple: self.init(r: 128 / 255, g: 0, b: 128 / 255)
        case .rebeccapurple: self.init(r: 102 / 255, g: 51 / 255, b: 153 / 255)
        case .red: self.init(r: 255 / 255, g: 0, b: 0)
        case .rosybrown: self.init(r: 188 / 255, g: 143 / 255, b: 143 / 255)
        case .royalblue: self.init(r: 65 / 255, g: 105 / 255, b: 225 / 255)
        case .saddlebrown: self.init(r: 139 / 255, g: 69 / 255, b: 19 / 255)
        case .salmon: self.init(r: 250 / 255, g: 128 / 255, b: 114 / 255)
        case .sandybrown: self.init(r: 244 / 255, g: 164 / 255, b: 96 / 255)
        case .seagreen: self.init(r: 46 / 255, g: 139 / 255, b: 87 / 255)
        case .seashell: self.init(r: 255 / 255, g: 245 / 255, b: 238 / 255)
        case .sienna: self.init(r: 160 / 255, g: 82 / 255, b: 45 / 255)
        case .silver: self.init(r: 192 / 255, g: 192 / 255, b: 192 / 255)
        case .skyblue: self.init(r: 135 / 255, g: 206 / 255, b: 235 / 255)
        case .slateblue: self.init(r: 106 / 255, g: 90 / 255, b: 205 / 255)
        case .slategray: self.init(r: 112 / 255, g: 128 / 255, b: 144 / 255)
        case .slategrey: self.init(r: 112 / 255, g: 128 / 255, b: 144 / 255)
        case .snow: self.init(r: 255 / 255, g: 250 / 255, b: 250 / 255)
        case .springgreen: self.init(r: 0, g: 255 / 255, b: 127 / 255)
        case .steelblue: self.init(r: 70 / 255, g: 130 / 255, b: 180 / 255)
        case .tan: self.init(r: 210 / 255, g: 180 / 255, b: 140 / 255)
        case .teal: self.init(r: 0, g: 128 / 255, b: 128 / 255)
        case .thistle: self.init(r: 216 / 255, g: 191 / 255, b: 216 / 255)
        case .tomato: self.init(r: 255 / 255, g: 99 / 255, b: 71 / 255)
        case .turquoise: self.init(r: 64 / 255, g: 224 / 255, b: 208 / 255)
        case .violet: self.init(r: 238 / 255, g: 130 / 255, b: 238 / 255)
        case .wheat: self.init(r: 245 / 255, g: 222 / 255, b: 179 / 255)
        case .white: self.init(r: 255 / 255, g: 255 / 255, b: 255 / 255)
        case .whitesmoke: self.init(r: 245 / 255, g: 245 / 255, b: 245 / 255)
        case .yellow: self.init(r: 255 / 255, g: 255 / 255, b: 0)
        case .yellowgreen: self.init(r: 154 / 255, g: 205 / 255, b: 50 / 255)
        case .transparent, .currentColor:
            // These are context-dependent and cannot be converted to a fixed sRGB value
            return nil
        }
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
