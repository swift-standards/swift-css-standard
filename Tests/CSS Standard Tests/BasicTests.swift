// BasicTests.swift
// CSS Standard
//
// Basic smoke tests for CSS Standard package

import Testing
@testable import CSS_Standard

@Suite
struct `CSS Standard - Basic Tests` {
    @Test func `package imports successfully`() {
        // This test passes if the package compiles and imports work
        #expect(Bool(true))
    }

    @Test func `can create CSSOM types`() {
        // Test that we can use CSSOM types through the re-export
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

        // Note: DashedIdent exists in both W3C CSSOM and W3C CSS Images
        // Using explicit module qualification for clarity
        let dashedIdent = W3C_CSSOM.DashedIdent("primary-color")
        #expect(dashedIdent.description == "--primary-color")
    }
}
