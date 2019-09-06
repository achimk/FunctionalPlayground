//: [Previous](@previous)

import Foundation

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

runAllTests()

//: [Next](@next)
