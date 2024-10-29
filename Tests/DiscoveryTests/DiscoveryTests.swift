import Discovery
import Testing

private protocol HasValue {
  static var value: Int { get }
}
private protocol Marker {}
private protocol Marker2 {}

@Discoverable private struct MyType: Marker, HasValue {
  static let value = 1
}
@Discoverable private struct MyType2: Marker2, HasValue {
  static let value = 2
}

private struct MyType3 {}
@Discoverable extension MyType3: Marker, HasValue {
  static let value = 3
}

struct DiscoveryTests {
  @Test
  func testDiscover() throws {
    let discovered = discover() as? [HasValue.Type] ?? []
    #expect(discovered.map { $0.value } == [1, 2, 3])
  }

  @Test
  func testDiscoverMarker() throws {
    let discovered = discover(Marker.self) as? [HasValue.Type] ?? []
    #expect(discovered.map { $0.value } == [1, 3])
  }
}
