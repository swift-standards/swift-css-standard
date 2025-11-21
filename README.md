# swift-css-standard

A unified facade for W3C CSS standards in Swift.

## Overview

`swift-css-standard` provides a clean, unified API for working with CSS in Swift, built on top of the comprehensive [swift-w3c-css](https://github.com/swift-standards/swift-w3c-css) implementation.

This package follows the same pattern as [swift-html-standard](https://github.com/swift-standards/swift-html-standard), providing a single entry point for CSS functionality with optional granular imports for specific needs.

## Features

- ✅ **Complete W3C CSS Implementation**: Built on swift-w3c-css covering all major CSS specifications
- ✅ **CSSOM Foundation**: Uses swift-cssom for spec-compliant serialization
- ✅ **Type-Safe**: Leverages Swift's type system for compile-time CSS validation
- ✅ **Modular**: Import only what you need or use the umbrella module
- ✅ **Well-Documented**: Extensive inline documentation with spec references

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-standards/swift-css-standard", from: "0.1.0")
]
```

## Usage

### Full Import (Recommended)

```swift
import CSS_Standard

// Access all CSS functionality
let color = Color.hex("#FF0000")
let url = Url("images/background.png")
let ident = CustomIdent("my-animation")
```

### Granular Imports

For specific use cases, you can import individual modules:

```swift
// For CSS properties
import CSS_Standard_Properties

// For CSS types (colors, lengths, etc.)
import CSS_Standard

// For CSS at-rules (@media, @keyframes, etc.)
import CSS_Standard_AtRules
```

## What's Included

This package re-exports all modules from [swift-w3c-css](https://github.com/swift-standards/swift-w3c-css):

### Core Modules
- CSSOM (serialization, strings, URLs, identifiers)
- CSS Values (lengths, percentages, numbers, etc.)
- CSS Color (color spaces, named colors, transparency)
- CSS Selectors (type, class, ID, pseudo-classes, etc.)

### Layout Modules
- Display, Positioning, Flexbox, Grid
- Box Model, Sizing, Overflow

### Typography Modules
- Fonts, Text, Writing Modes, Text Decoration

### Visual Effects
- Backgrounds, Images, Borders, Shadows
- Transforms, Transitions, Animations
- Filters, Blend Modes, Masks

### Advanced Features
- Media Queries, Container Queries
- Custom Properties (CSS Variables)
- Scroll Behavior, Contain, Will-Change

## Migration from swift-css-types

If you're migrating from `swift-css-types`, the transition is straightforward:

**Before:**
```swift
import CSSTypes
import CSSPropertyTypes
```

**After:**
```swift
import CSS_Standard
// or
import CSS_Standard_Properties
```

The API surface is similar, but `swift-css-standard` provides:
- W3C specification compliance
- CSSOM-based serialization
- More comprehensive CSS coverage
- Better type safety

## Architecture

```
swift-css-standard (facade/umbrella)
    └── swift-w3c-css (implementation)
        └── swift-cssom (foundation)
```

This package is a thin wrapper that re-exports `swift-w3c-css`, providing:
- A clean, unified API
- Backward compatibility type aliases
- Convenient product organization

## Requirements

- Swift 6.0+
- macOS 15.0+, iOS 18.0+, tvOS 18.0+, watchOS 11.0+, macCatalyst 18.0+

## Related Packages

- **[swift-w3c-css](https://github.com/swift-standards/swift-w3c-css)** - Comprehensive W3C CSS implementation (underlying implementation)
- **[swift-cssom](https://github.com/swift-standards/swift-cssom)** - W3C CSSOM specification (foundation layer)
- **[swift-html-standard](https://github.com/swift-standards/swift-html-standard)** - Unified HTML API (sister package)

## License

Apache 2.0
