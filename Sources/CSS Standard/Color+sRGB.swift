import Byte
public import Color_Standard
import IEC_61966
import RFC_4648
public import W3C_CSS_Values

extension IEC_61966.`2`.`1`.sRGB {

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

            self.init(h: h.normalizedDegrees(), s: s / 100.0, l: l / 100.0)

        case .hsla(let h, let s, let l, _):
            self.init(h: h.normalizedDegrees(), s: s / 100.0, l: l / 100.0)

        case .hwb(let h, let w, let b):

            self.init(hue: h.normalizedDegrees(), whiteness: w / 100.0, blackness: b / 100.0)

        case .hex(let hex):
            self.init(hex)

        case .named(let named):
            if let srgb = Self(named) {
                self = srgb
            } else {
                return nil
            }

        case .lab(let l, let a, let b):

            let lab = Color_Standard.Color.LAB(l: l, a: a, b: b)
            self = lab.converted(to: Self.self)

        case .lch(let l, let c, let h):

            let lch = Color_Standard.Color.LCH(l: l, c: c, h: h)
            self = lch.converted(to: Self.self)

        case .oklab(let l, let a, let b):

            let oklab = Color_Standard.Color.Oklab(l: l, a: a, b: b)
            self = oklab.converted(to: Self.self)

        case .oklch(let l, let c, let h):

            let oklch = Color_Standard.Color.Oklch(l: l, c: c, h: h)
            self = oklch.converted(to: Self.self)

        case .mix, .system, .currentColor, .transparent:

            return nil
        }
    }

    public init(_ hex: W3C_CSS_Values.HexColor) {
        let value =
            hex.value.hasPrefix("#")
            ? String(hex.value.dropFirst())
            : hex.value

        let expanded: String
        switch value.count {
        case 3:
            let chars = Array(value)
            expanded = "\(chars[0])\(chars[0])\(chars[1])\(chars[1])\(chars[2])\(chars[2])"

        case 4:
            let chars = Array(value)
            expanded =
                "\(chars[0])\(chars[0])\(chars[1])\(chars[1])\(chars[2])\(chars[2])\(chars[3])\(chars[3])"

        default:
            expanded = value
        }

        guard let bytes = [Byte](hexEncoded: expanded), bytes.count >= 3 else {
            self.init(r: 0, g: 0, b: 0)
            return
        }

        self.init(
            r: Double(bytes[0].underlying) / 255.0,
            g: Double(bytes[1].underlying) / 255.0,
            b: Double(bytes[2].underlying) / 255.0
        )
    }

    public init?(_ named: W3C_CSS_Values.NamedColor) {
        guard let srgb = named.sRGB else { return nil }
        self = srgb
    }
}

extension W3C_CSS_Values.Color {

    public init(_ srgb: IEC_61966.`2`.`1`.sRGB) {
        self = .rgb(
            Int((srgb.r * 255).rounded()),
            Int((srgb.g * 255).rounded()),
            Int((srgb.b * 255).rounded())
        )
    }

    public static func hsl(
        hue: IEC_61966.`2`.`1`.Hue,
        saturation: IEC_61966.`2`.`1`.Saturation,
        lightness: IEC_61966.`2`.`1`.Lightness
    ) -> Color {

        .hsl(
            .number(.init(hue.degrees)),
            saturation.value * 100,
            lightness.value * 100
        )
    }

    public static func hwb(
        hue: IEC_61966.`2`.`1`.Hue,
        whiteness: IEC_61966.`2`.`1`.Whiteness,
        blackness: IEC_61966.`2`.`1`.Blackness
    ) -> Color {

        .hwb(
            .number(.init(hue.degrees)),
            whiteness.value * 100,
            blackness.value * 100
        )
    }
}

extension W3C_CSS_Values.Color {

    public typealias sRGB = IEC_61966.`2`.`1`.sRGB
}
