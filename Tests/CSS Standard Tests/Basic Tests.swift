import Testing

@testable import CSS_Standard

enum `Basic Tests` {}

extension `Basic Tests` {
    @Suite
    struct `CSS Standard - Basic Tests` {
        @Suite
        struct Unit {
            @Test func `package imports successfully`() {

                #expect(Bool(true))
            }

            @Test func `can create CSSOM types`() {

                let str = W3C.CSSOM.String("test")
                #expect(str.description == "\"test\"")

                let url = W3C.CSSOM.Url("path/to/file.jpg")
                #expect(url.description == "url(\"path/to/file.jpg\")")
            }

            @Test func `can create identifier types`() {
                let ident = W3C.CSSOM.Ident("block")
                #expect(ident.description == "block")

                let customIdent = W3C.CSSOM.CustomIdent("my-animation")
                #expect(customIdent.description == "my-animation")

                let dashedIdent = W3C.CSSOM.DashedIdent("primary-color")
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
}
