// swift-tools-version: 5.10

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
    .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "509.1.0"),
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
  ],
  cxxLanguageStandard: .cxx20
)
