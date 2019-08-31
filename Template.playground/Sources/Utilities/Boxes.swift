import Foundation

public class Box<T> {
    
    public fileprivate(set) var value: T
    
    public init(_ value: T) {
        self.value = value
    }
}

public class MutableBox<T>: Box<T> {
    
    public func set(_ value: T) {
        self.value = value
    }
}

public struct WeakBox: Hashable {
    
    public weak var inner: AnyObject?
    
    public init(_ inner: AnyObject) {
        self.inner = inner
    }
    
    public var hashValue: Int {
        return inner.map { ObjectIdentifier($0).hashValue } ?? 0
    }
    
    public static func ==(lhs: WeakBox, rhs: WeakBox) -> Bool {
        return lhs.inner === rhs.inner
    }
    
    public static func ==(lhs: WeakBox, rhs: AnyObject) -> Bool {
        return lhs.inner === rhs
    }
}

