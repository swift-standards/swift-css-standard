// CSS Standard.swift
// CSS Standard
//
// Main umbrella module re-exporting W3C CSS and IEC 61966 (sRGB)

@_exported import IEC_61966
@_exported import W3C_CSS
@_exported import enum W3C_CSS_Shared.W3C_CSS

// Note: All types from W3C CSS are available directly through the re-export
// For migration from swift-css-types:
// - CSSTypes, CSSPropertyTypes, CSS_Standard → use types from W3C_CSS directly
// - All CSS properties, values, and types are available through this import

public typealias Color = W3C_CSS_Color.Color

extension Color {
    public typealias Value = W3C_CSS_Values.Color
}


public typealias CSS = W3C_CSS
