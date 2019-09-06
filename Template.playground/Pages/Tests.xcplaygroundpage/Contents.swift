//: [Previous](@previous)

import Foundation

test("Collection+Safe") {
    let c = [1, 2, 3]
    let some = c[safe: 0]
    let none = c[safe: 10]
    expectTrue(some.isPresent)
    expectFalse(none.isPresent)
}

test("Optional+Present") {
    let a: Int? = 1
    let b: Int? = nil
    
    expectTrue(a.isPresent)
    a.ifPresent { (data) in
        expectEqual(data, 1)
    }
    expectFalse(b.isPresent)
}

test("Optional+Zip") {
    let a: Int? = 1
    let b: Int? = 2
    
    let result = zip(a, b)
    
    expectTrue(result.isPresent)
    result.ifPresent { (data) in
        expectEqual(data.0, 1)
        expectEqual(data.1, 2)
    }
}

test("Curry") {
    let add: (Int, Int) -> Int = { $0 + $1 }
    let multiply: (Int, Int) -> Int = { $0 * $1 }
    let addAndMultiply: (Int, Int, Int) -> Int = { ($0 + $1) * $2 }
    
    // Partial Application
    let curriedAdd = curry(add)(1)
    let curriedMultiply = curry(multiply)(2)
    let curriedAddAndMultiply = curry(addAndMultiply)(1)(2)
    
    let result = 1 |> curriedAdd |> curriedMultiply |> curriedAddAndMultiply
    
    expectEqual(result, 12)
}

test("Uncurry") {
    let add: (Int) -> (Int) -> Int = { l in { r in l + r } }
    let multiply: (Int) -> (Int) -> Int = { l in { r in l * r } }
    let addAndMultiply: (Int) -> (Int) -> (Int) -> Int = { l in { r in { v in (l + r) * v } } }

    let uncurryAdd = uncurry(add)
    let uncurryMultiply = uncurry(multiply)
    let uncurryAddAndMultiply = uncurry(addAndMultiply)
    
    var result = uncurryAdd(1, 1)
    result = uncurryMultiply(2, result)
    result = uncurryAddAndMultiply(1, 2, result)
    
    expectEqual(result, 12)
}

test("NonEmpty") {
    let n = NonEmpty<[Int]>(1)
    expectEqual(n.head, 1)
    expectEqual(n.tail, [])
}

test("Tagged") {
    typealias PersonId = Tagged<Person, Int>
    struct Person {
        let id: PersonId
    }
    
    let person = Person(id: PersonId(rawValue: 1))
    expectEqual(person.id, PersonId(rawValue: 1))
}

test("TaggedMoney") {
    let cents = Cents(rawValue: 100.0)
    let dollars = Dollars(rawValue: 1.0)
    expectEqual(cents.dollars, dollars)
    expectEqual(dollars.cents, cents)
}

test("TaggedTime") {
    let milliseconds = Milliseconds(rawValue: 1000.0)
    let seconds = Seconds(rawValue: 1.0)
    expectEqual(milliseconds.seconds, seconds)
    expectEqual(seconds.milliseconds, milliseconds)
}

test("Either") {
    var e = Either<Int, String>(1)
    expectEqual(e.left, 1)
    e = .init("1")
    expectEqual(e.right, "1")
}

test("Never") {
    let r = Result<Int, Never>(1)
    expectEqual(r.value, 1)
    expectTrue(r.isSuccess)
}

test("Result") {
    struct TestError: Swift.Error { }
    var r = Result<Int, TestError>(1)
    expectEqual(r.value, 1)
    expectTrue(r.isSuccess)
    r = .init(TestError())
    expectTrue(r.isFailure)
}

test("Result+Zip") {
    struct TestError: Swift.Error { }
    func sum(_ l: Int, _ r: Int) -> Int { return l + r }
    let l = Result<Int, TestError>(1)
    let r = Result<Int, TestError>(2)
    let s = Result.zip(l, r).map(sum)
    expectEqual(s.value, 3)
}

test("Monoid+String") {
    var s = String.zero
    s = s.append("1")
    s = s.append("2")
    s = s.append("3")
    expectEqual(s, "123")
}

test("Monoid+Set") {
    var s = Set<Int>.zero
    let a = Set<Int>.init(arrayLiteral: 1)
    let b = Set<Int>.init(arrayLiteral: 2)
    let c = Set<Int>.init(arrayLiteral: 3)
    let d = Set<Int>.init(arrayLiteral: 4)
    s = s.append(a)
    s = s.append(b)
    s = s.append(c)
    s = s.append(d)
    expectEqual(s.sorted(by: <), [1, 2, 3, 4])
}

runAllTests()

//: [Next](@next)
