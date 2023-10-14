//
//  MatrixRow+Operators.swift
//  ClothSimulation
//
//  Created by Reza on 1/15/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

// MARK: - Addition
public func +<S: MatrixElement & AdditiveArithmetic>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) -> RVec<S> {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [1, lhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = lhs.values[i].pointee + rhs.values[i].pointee
        (pointer + i).initialize(to: value)
    }
    
    return RVec<S>(SharedPointer(pointer), size)
}

public func +<V: Vector, S: MatrixElement & AdditiveArithmetic>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) -> V where V.Element == S {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [1, lhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = lhs.values[i].pointee + rhs.values[i].pointee
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +<S: MatrixElement & AdditiveArithmetic, V: Vector>(lhs: MatrixRow<S>, rhs: V) -> RVec<S> where V.Element == S {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [1, lhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = lhs.values[i].pointee + rhs[i]
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +<S: MatrixElement & AdditiveArithmetic, V: Vector>(lhs: V, rhs: MatrixRow<S>) -> RVec<S> where V.Element == S {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [1, rhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = lhs[i] + rhs.values[i].pointee
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +<S: MatrixElement & AdditiveArithmetic, V1: Vector, V2: Vector>(lhs: MatrixRow<S>, rhs: V1) -> V2 where V1.Element == S, V2.Element == S {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [V2.Rows == 1 ? 1 : lhs.count,
                            V2.Cols == 1 ? 1 : lhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = lhs.values[i].pointee + rhs[i]
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +=<S: MatrixElement & AdditiveArithmetic, V: Vector>(lhs: MatrixRow<S>, rhs: V) where V.Element == S {
    assert(lhs.count == rhs.count)
    
    for i in 0..<lhs.count {
        lhs.values[i].pointee += rhs[i]
    }
}

public func +=<S: MatrixElement & AdditiveArithmetic>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) {
    assert(lhs.count == rhs.count)
    
    for i in 0..<lhs.count {
        lhs.values[i].pointee += rhs.values[i].pointee
    }
}

// MARK: - Subtraction
public func -<S: MatrixElement & SignedNumeric>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) -> RVec<S> {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [1, lhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = lhs.values[i].pointee - rhs.values[i].pointee
        (pointer + i).initialize(to: value)
    }
    
    return RVec<S>(SharedPointer(pointer), size)
}

public func -<V: Vector, S: MatrixElement & SignedNumeric>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) -> V where V.Element == S {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [1, lhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = lhs.values[i].pointee - rhs.values[i].pointee
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

// MARK: - Division
public func /<T: MatrixElement>(lhs: MatrixRow<T>, rhs: T) -> RVec<T> where T: FloatingPoint {
    let size: MatrixSize = [1, lhs.count]
    let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value = lhs.values[i].pointee / rhs
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func /=<T: MatrixElement & FloatingPoint>(lhs: MatrixRow<T>, rhs: T) {
    for i in 0..<lhs.count {
        lhs.values[i].pointee /= rhs
    }
}

// MARK:  -Multiplication
public func *=<T: MatrixElement>(lhs: MatrixRow<T>, rhs: T) where T: Numeric {
    for i in 0..<lhs.count {
        lhs.values[i].pointee *= rhs
    }
}

// MARK: - Assignments
public func <<==<S: MatrixElement>(lhs: MatrixRow<S>, rhs: [S]) {
    assert(lhs.count == rhs.count)
    
    for i in 0..<lhs.count {
        lhs.values[i].pointee = rhs[i]
    }
}
