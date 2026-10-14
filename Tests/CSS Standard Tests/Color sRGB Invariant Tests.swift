import IEC_61966
import Testing

@testable import CSS_Standard

@Suite
struct `Color from a mutated sRGB value` {
    @Test
    func `a NaN assigned to an sRGB component converts to a CSS color instead of trapping`() {
        var srgb = IEC_61966.`2`.`1`.SRGB(r: 0.5, g: 0.5, b: 0.5)
        srgb.r = .nan
        srgb.g = 2
        #expect(W3C_CSS_Values.Color(srgb) == .rgb(0, 255, 128))
    }
}
