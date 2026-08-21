import Testing

@testable import CSS_Standard

@Suite
struct `CSS Standard - Basic Tests` {
    @Suite
    struct Unit {
        @Test func `package imports successfully`() {

            #expect(Bool(true))
        }

        @Test func `can create CSSOM types`() {

            let str = CSSString("test")
            #expect(str.description == "\"test\"")

            let url = Url("path/to/file.jpg")
            #expect(url.description == "url(\"path/to/file.jpg\")")
        }

        @Test func `can create identifier types`() {
            let ident = Ident("block")
            #expect(ident.description == "block")

            let customIdent = CustomIdent("my-animation")
            #expect(customIdent.description == "my-animation")

            let dashedIdent = W3C_CSSOM.DashedIdent("primary-color")
            #expect(dashedIdent.description == "--primary-color")
        }
    }

    @Suite
    struct `Edge Case` {
    }

    @Suite
    struct Integration {
    }
}
