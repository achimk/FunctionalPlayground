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

test("Compose >->") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let add1_double_square = add1 >-> double >-> square
    
    expectEqual(add1_double_square(1), 16)
}

test("Compose <-<") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let square_double_add1 = add1 <-< double <-< square
    
    expectEqual(square_double_add1(1), 3)
}

test("Array Compose >->") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }

    let add1_double_square: (Int) -> [Int] = (add1 >-> pure)
        >-> (double >-> pure)
        >-> (square >-> pure)

    expectEqual(add1_double_square(1), [16])
}

test("Array Compose <-<") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }

    let square_double_add1: (Int) -> [Int] = (pure <-< add1)
        <-< (pure <-< double)
        <-< (pure <-< square)

    expectEqual(square_double_add1(1), [3])
}

test("Optional Compose >->") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let add1_double_square: (Int) -> Int? = (add1 >-> pure)
            >-> (double >-> pure)
            >-> (square >-> pure)
    
    expectEqual(add1_double_square(1), 16)
}

test("Optional Compose <-<") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let square_double_add1: (Int) -> Int? = (pure <-< add1)
        <-< (pure <-< double)
        <-< (pure <-< square)
    
    expectEqual(square_double_add1(1), 3)
}

test("Result Compose >->") {
    struct TestError: Swift.Error, Equatable { }
    
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let add1_double_square: (Int) -> Result<Int,TestError> = (add1 >-> pure)
        >-> (double >-> pure)
        >-> (square >-> pure)
    
    expectEqual(add1_double_square(1).value, 16)
}

test("Result Compose <-<") {
    struct TestError: Swift.Error, Equatable { }
    
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let square_double_add1: (Int) -> Result<Int,TestError> = (pure <-< add1)
        <-< (pure <-< double)
        <-< (pure <-< square)
    
    expectEqual(square_double_add1(1).value, 3)
}

test("Pipe |>") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let result = 1 |> add1 |> double |> square
    
    expectEqual(result, 16)
}

test("Array Bind >>-") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }

    let result = [1, 2, 3]
        >>- (add1 >-> pure)
        >>- (double >-> pure)
        >>- (square >-> pure)

    expectEqual(result, [16, 36, 64])
}

test("Array Bind -<<") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }

    let result = (pure <-< add1)
        -<< (pure <-< double)
        -<< (pure <-< square)
        -<< [1, 2, 3]

    expectEqual(result, [3, 9, 19])
}

test("Optional Bind >>-") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let some = Optional.some(1) >>- add1 >>- double >>- square
    let none = Optional.none  >>- add1 >>- double >>- square
    
    expectEqual(some, 16)
    expectEqual(none, nil)
}

test("Optional Bind -<<") {
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let some = add1 -<< double -<< square -<< Optional.some(1)
    let none = add1 -<< double -<< square -<< Optional.none
 
    expectEqual(some, 3)
    expectEqual(none, nil)
}

test("Result Bind >>-") {
    struct TestError: Swift.Error, Equatable { }
    
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let success = Result<Int, TestError>(1)
        >>- (add1 >-> pure)
        >>- (double >-> pure)
        >>- (square >-> pure)
    let failure = Result<Int, TestError>(TestError())
        >>- (add1 >-> pure)
        >>- (double >-> pure)
        >>- (square >-> pure)
    
    expectEqual(success.value, 16)
    expectEqual(failure.error, TestError())
}

test("Result Bind -<<") {
    struct TestError: Swift.Error, Equatable { }
    
    let add1: (Int) -> Int = { $0 + 1 }
    let double: (Int) -> Int = { $0 + $0 }
    let square: (Int) -> Int = { $0 * $0 }
    
    let success = (add1 >-> pure)
        -<< (double >-> pure)
        -<< (square >-> pure)
        -<< Result<Int, TestError>(1)
    let failure = (add1 >-> pure)
        -<< (double >-> pure)
        -<< (square >-> pure)
        -<< Result<Int, TestError>(TestError())
    
    expectEqual(success.value, 3)
    expectEqual(failure.error, TestError())
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

runAllTests()

//: [Next](@next)
