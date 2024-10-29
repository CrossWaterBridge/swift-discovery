@testable import DiscoveryMacros
import MacroTesting
import Testing

struct DiscoverableDeclarationMacroTests {
  @Test
  func testDiscoverable() throws {
    assertMacro(["Discoverable": DiscoverableDeclarationMacro.self]) {
      """
      @Discoverable struct MyType: Int {}
      """
    } expansion: {
      """
      struct MyType: Int {

          @available(*, deprecated, message: "This type is an implementation detail of the discovery library. Do not use it directly.")
          public enum __macro_local_28__🐿️$discoverable_container__fMu_: Discovery.__DiscoverableContainer {
            static var __markers: [Any.Type] {
                [Int.self]
            }
            static var __type: Any.Type {
                MyType.self
            }
          }
      }
      """
    }
  }
}
