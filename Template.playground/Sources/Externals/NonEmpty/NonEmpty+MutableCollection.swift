// Swift 5 compactibility:
//extension NonEmpty: MutableCollection where C: MutableCollection {
//  public subscript(position: Index) -> Element {
//    get {
//      switch position {
//      case .head:
//        return self.head
//      case let .tail(index):
//        return self.tail[index]
//      }
//    }
//    set {
//      switch position {
//      case .head:
//        self.head = newValue
//      case let .tail(index):
//        self.tail[index] = newValue
//      }
//    }
//    _modify {
//      switch position {
//      case .head:
//        yield &self.head
//      case let .tail(index):
//        yield &self.tail[index]
//      }
//    }
//  }
//}
//
//extension NonEmpty where C: MutableCollection, C.Index == Int {
//  public subscript(position: Int) -> Element {
//    get {
//      return self[position == 0 ? .head : .tail(self.tail.startIndex + position - 1)]
//    }
//    set {
//      self[position == 0 ? .head : .tail(self.tail.startIndex + position - 1)] = newValue
//    }
//    _modify {
//      yield &self[position == 0 ? .head : .tail(self.tail.startIndex + position - 1)]
//    }
//  }
//}

// Swift 4.2 compactibility
extension NonEmpty: MutableCollection where C: MutableCollection {
    public subscript(position: Index) -> Element {
        get {
            switch position {
            case .head:
                return self.head
            case let .tail(index):
                return self.tail[index]
            }
        }
        set {
            switch position {
            case .head:
                self.head = newValue
            case let .tail(index):
                self.tail[index] = newValue
            }
        }
    }
}

extension NonEmpty where C: MutableCollection, C.Index == Int {
    public subscript(position: Int) -> Element {
        get {
            return self[position == 0 ? .head : .tail(self.tail.startIndex + position - 1)]
        }
        set {
            self[position == 0 ? .head : .tail(self.tail.startIndex + position - 1)] = newValue
        }
    }
}
