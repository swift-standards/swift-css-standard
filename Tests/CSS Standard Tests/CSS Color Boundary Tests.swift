import Testing

@testable import CSS_Standard

@Suite
struct `CSS color conversion boundaries` {
    private typealias SRGB = W3C_CSS_Values.Color.sRGB

    private func channels(_ hex: String) -> [Int] {
        let color = SRGB(W3C_CSS_Values.HexColor(hex))
        return [color.r255, color.g255, color.b255]
    }

    @Test
    func `three six and eight digit hex agree`() {
        #expect(channels("#f80") == [255, 136, 0])
        #expect(channels("#ff8800") == [255, 136, 0])
        #expect(channels("#ff8800cc") == [255, 136, 0])
        #expect(channels("#f80c") == [255, 136, 0])
    }

    @Test
    func `hex without a hash sign is accepted`() {
        #expect(channels("00ff7f") == [0, 255, 127])
    }

    @Test
    func `the hex extremes map to black and white`() {
        #expect(channels("#000") == [0, 0, 0])
        #expect(channels("#FFFFFF") == [255, 255, 255])
    }

    @Test
    func `an sRGB color written back as rgb keeps its channels`() {
        #expect(W3C_CSS_Values.Color(SRGB(r255: 255, g255: 128, b255: 0)) == .rgb(255, 128, 0))
        #expect(W3C_CSS_Values.Color(SRGB(r255: 0, g255: 0, b255: 0)) == .rgb(0, 0, 0))
    }

    @Test
    func `rgba drops only the alpha channel`() {
        let opaque = SRGB(W3C_CSS_Values.Color.rgb(10, 20, 30))
        let translucent = SRGB(W3C_CSS_Values.Color.rgba(10, 20, 30, 0.5))
        #expect(opaque?.r255 == translucent?.r255)
        #expect(opaque?.b255 == translucent?.b255)
    }

    @Test
    func `colors without a fixed value have no sRGB form`() {
        #expect(SRGB(W3C_CSS_Values.Color.currentColor) == nil)
        #expect(SRGB(W3C_CSS_Values.Color.transparent) == nil)
    }
}
