import SwiftSyntax
import SwiftSyntaxMacros

/// A type describing the expansion of the `@Discoverable` attribute macro.
///
/// This type is used to implement the `@Discoverable` attribute macro. Do not use it
/// directly.
public struct DiscoverableDeclarationMacro: MemberMacro, Sendable {
  public static func expansion(
    of node: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    let tagTypes = declaration.inheritanceClause?.inheritedTypes.map { $0.type } ?? []

    // The emitted type must be public or the compiler can optimize it away
    // (since it is not actually used anywhere that the compiler can see).
    let enumName = context.makeUniqueName("__🐿️$discoverable_container__")
    return [
      """
      @available(*, deprecated, message: "This type is an implementation detail of the discovery library. Do not use it directly.")
      public enum \(enumName): Discovery.__DiscoverableContainer {
        static var __markers: [Any.Type] { [\(raw: tagTypes.map { "\($0.trimmed).self" }.joined(separator: ", "))] }
        static var __type: Any.Type { \(declaration.type.trimmed).self }
      }
      """,
    ]
  }
}
