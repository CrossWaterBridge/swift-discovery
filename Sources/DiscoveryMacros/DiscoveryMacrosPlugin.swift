import SwiftCompilerPlugin
import SwiftSyntaxMacros

/// The main entry point for the compiler plugin executable that implements
/// macros declared in the `Testing` module.
@main
struct DiscoveryMacrosPlugin: CompilerPlugin {
  var providingMacros: [any Macro.Type] {
    [
      DiscoverableDeclarationMacro.self,
    ]
  }
}
