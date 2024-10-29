// swift-tools-version: 6.0

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "swift-discovery",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .watchOS(.v6),
    .tvOS(.v13),
    .macCatalyst(.v13),
    .visionOS(.v1),
  ],
  products: [
    .library(name: "Discovery", targets: ["Discovery"]),
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-syntax.git", "509.0.0"..<"601.0.0-prerelease"),
    .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.5.2"),
  ],
  targets: [
    .target(
      name: "_DiscoveryInternals"
    ),
    .target(
      name: "Discovery",
      dependencies: [
        "_DiscoveryInternals",
        "DiscoveryMacros",
      ]
    ),
    .testTarget(
      name: "DiscoveryTests",
      dependencies: [
        "Discovery",
      ]
    ),
    .macro(
      name: "DiscoveryMacros",
      dependencies: [
        .product(name: "SwiftDiagnostics", package: "swift-syntax"),
        .product(name: "SwiftSyntax", package: "swift-syntax"),
        .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
        .product(name: "SwiftParser", package: "swift-syntax"),
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),
    .testTarget(
      name: "DiscoveryMacrosTests",
      dependencies: [
        "DiscoveryMacros",
        .product(name: "MacroTesting", package: "swift-macro-testing"),
      ]
    ),
  ],
  swiftLanguageModes: [.v6],
  cxxLanguageStandard: .cxx20
)
