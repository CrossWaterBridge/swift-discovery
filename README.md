# Swift Discovery

Discovery mechanism based on the implementation of [swift-testing](https://github.com/swiftlang/swift-testing).

See [this discussion](https://forums.swift.org/t/how-does-swift-testing-test-discovery-work/72771/2) on the Swift Forum for caveats.

## Overview

Swift Discovery provides tools to mark types at compile time for discovery at runtime.

To begin, mark a type as discoverable by using the `@Discoverable` macro:

```swift
@Discoverable
enum Foo {}
```

Then you can discover all marked types at runtime:

```swift
let types: [Any.Type] = discover()
for type in types {
  print(type.self)  // Foo
}
```

You can also discover all marked types that conform to a specific protocol:

```swift
protocol HasValue {
  static var value: Int { get }
}

@Discoverable
enum Bar: HasValue {
  static let value = 42
}

let types = discover(HasValue.self) as? [HasValue.Type] ?? []
for type in types {
  print(type.self, type.value)  // Bar 42
}
```

Note that the `@Discoverable` macro must be placed on the declaration of the marking protocol conformance.

## Installation

You can add Swift Discovery to an Xcode project by adding it to your project as a package.

> https://github.com/CrossWaterBridge/swift-discovery

Add the [`-ObjC` linker flag](https://developer.apple.com/library/archive/qa/qa1490/_index.html) in your `Other Linker Settings` in your target's build settings.

If you want to use Swift Discovery in an SPM project, it's as simple as adding it to your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/CrossWaterBridge/swift-discovery.git", from: "0.1.0")
]
```

And then adding the product to any target that needs access to the library:

```swift
.product(name: "Discovery", package: "swift-discovery")
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
