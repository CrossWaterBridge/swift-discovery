//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for Swift project authors
//

import SwiftSyntax

extension DeclGroupSyntax {
  /// The type declared or extended by this instance.
  var type: TypeSyntax {
    if let namedDecl = asProtocol((any NamedDeclSyntax).self) {
      return TypeSyntax(IdentifierTypeSyntax(name: namedDecl.name))
    } else if let extensionDecl = `as`(ExtensionDeclSyntax.self) {
      return extensionDecl.extendedType
    }
    fatalError("Unexpected DeclGroupSyntax type \(Swift.type(of: self))")
  }
}
