import _DiscoveryInternals

/// A protocol describing a type that is discoverable.
///
/// - Warning: This protocol is used to implement the `@Discoverable` macro. Do not use it directly.
@_alwaysEmitConformanceMetadata
public protocol __DiscoverableContainer {
  /// The marker protocols associated with this container.
  static var __markers: [Any.Type] { get }

  /// The type contained by this container.
  static var __type: Any.Type { get }
}

private let _discoverableContainerTypeNameMagic = "__🐿️$discoverable_container__"

/// Discovers and returns an array of types annotated with `@Discoverable`.
///
/// - Returns: An array of types annotated with `@Discoverable`.
public func discover() -> [Any.Type] {
  var discoveredType = [Any.Type]()
  enumerateTypes(withNamesContaining: _discoverableContainerTypeNameMagic) { type, _ in
    if let container = type as? __DiscoverableContainer.Type {
      discoveredType.append(container.__type)
    }
  }
  return discoveredType
}

/// Discovers and returns an array of types annotated with `@Discoverable`.
///
/// - Parameter marker: The marker protocol to which desired discoverable types conform.
/// - Returns: An array of types annotated with `@Discoverable`.
public func discover<Marker>(_ marker: Marker.Type) -> [Any.Type] {
  var discoveredType = [Any.Type]()
  enumerateTypes(withNamesContaining: _discoverableContainerTypeNameMagic) { type, _ in
    if let container = type as? __DiscoverableContainer.Type {
      for containerMarker in container.__markers {
        if containerMarker == marker {
          discoveredType.append(container.__type)
        }
      }
    }
  }
  return discoveredType
}

/// The type of callback called by ``enumerateTypes(withNamesContaining:_:)``.
///
/// - Parameters:
///   - type: A Swift type.
///   - stop: An `inout` boolean variable indicating whether type enumeration
///     should stop after the function returns. Set `stop` to `true` to stop
///     type enumeration.
private typealias TypeEnumerator = (_ type: Any.Type, _ stop: inout Bool) -> Void

/// Enumerate all types known to Swift found in the current process whose names
/// contain a given substring.
///
/// - Parameters:
///   - nameSubstring: A string which the names of matching classes all contain.
///   - body: A function to invoke, once per matching type.
private func enumerateTypes(withNamesContaining nameSubstring: String, _ typeEnumerator: TypeEnumerator) {
  withoutActuallyEscaping(typeEnumerator) { typeEnumerator in
    withUnsafePointer(to: typeEnumerator) { context in
      swt_enumerateTypes(withNamesContaining: nameSubstring, .init(mutating: context)) { type, stop, context in
        let typeEnumerator = context!.load(as: TypeEnumerator.self)
        let type = unsafeBitCast(type, to: Any.Type.self)
        var stop2 = false
        typeEnumerator(type, &stop2)
        stop.pointee = stop2
      }
    }
  }
}
