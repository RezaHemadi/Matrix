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
    assert(lhs.columns == rhs.columns)
    
    let size: MatrixSize = [1, lhs.columns]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: lhs.columns)
    for j in 0..<lhs.columns {
        let value: S = lhs[j] + rhs[j]
        (pointer + j).initialize(to: value)
    }
    
    return RVec<S>(SharedPointer(pointer), size)
}

public func +<V: Vector, S: MatrixElement & AdditiveArithmetic>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) -> V where V.Element == S {
    assert(lhs.columns == rhs.columns)
    
    let size: MatrixSize = [1, lhs.columns]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: lhs.columns)
    for j in 0..<lhs.columns {
        let value: S = lhs[j] + rhs[j]
        (pointer + j).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +<S: MatrixElement & AdditiveArithmetic, V: Vector>(lhs: MatrixRow<S>, rhs: V) -> RVec<S> where V.Element == S {
    assert(lhs.columns == rhs.count)
    
    let size: MatrixSize = [1, lhs.columns]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: lhs.columns)
    
    for j in 0..<lhs.columns {
        let value: S = lhs[j] + rhs[j]
        (pointer + j).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +<S: MatrixElement & AdditiveArithmetic, V: Vector>(lhs: V, rhs: MatrixRow<S>) -> RVec<S> where V.Element == S {
    assert(lhs.count == rhs.columns)
    
    let size: MatrixSize = [1, rhs.columns]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: rhs.columns)
    
    for j in 0..<rhs.columns {
        let value: S = lhs[j] + rhs[j]
        (pointer + j).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +<S: MatrixElement & AdditiveArithmetic, V1: Vector, V2: Vector>(lhs: MatrixRow<S>, rhs: V1) -> V2 where V1.Element == S, V2.Element == S {
    assert(lhs.columns == rhs.count)
    
    let size: MatrixSize = [V2.Rows == 1 ? 1 : lhs.columns,
                            V2.Cols == 1 ? 1 : lhs.columns]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: lhs.columns)
    
    for j in 0..<lhs.columns {
        let value: S = lhs[j] + rhs[j]
        (pointer + j).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +=<S: MatrixElement & AdditiveArithmetic, V: Vector>(lhs: MatrixRow<S>, rhs: V) where V.Element == S {
    assert(lhs.columns == rhs.count)
    
    for j in 0..<lhs.columns {
        let index = lhs.indexFinder(j)
        lhs.values[index] += rhs[j]
    }
}

public func +=<S: MatrixElement & AdditiveArithmetic>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) {
    assert(lhs.columns == rhs.columns)
    
    for j in 0..<lhs.columns {
        let index = lhs.indexFinder(j)
        lhs.values[index] += rhs[j]
    }
}

// MARK: - Subtraction
public func -<S: MatrixElement & SignedNumeric>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) -> RVec<S> {
    assert(lhs.columns == rhs.columns)
    
    let size: MatrixSize = [1, lhs.columns]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: lhs.columns)
    for j in 0..<lhs.columns {
        (pointer + j).initialize(to: lhs[j] - rhs[j])
    }
    
    return RVec<S>(SharedPointer(pointer), size)
}

public func -<V: Vector, S: MatrixElement & SignedNumeric>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) -> V where V.Element == S {
    assert(lhs.columns == rhs.columns)
    
    let size: MatrixSize = [1, lhs.columns]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: lhs.columns)
    for j in 0..<lhs.columns {
        (pointer + j).initialize(to: lhs[j] - rhs[j])
    }
    
    return .init(SharedPointer(pointer), size)
}

// MARK: - Division
public func /<T: MatrixElement>(lhs: MatrixRow<T>, rhs: T) -> RVec<T> where T: FloatingPoint {
    let size: MatrixSize = [1, lhs.columns]
    let pointer: UnsafeMutablePointer<T> = .allocate(capacity: lhs.columns)
    
    for j in 0..<lhs.columns {
        let value = lhs[j] / rhs
        (pointer + j).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func /=<T: MatrixElement & FloatingPoint>(lhs: MatrixRow<T>, rhs: T) {
    for j in 0..<lhs.columns {
        let index = lhs.indexFinder(j)
        lhs.values[index] /= rhs
    }
}

// MARK:  -Multiplication
public func *=<T: MatrixElement>(lhs: MatrixRow<T>, rhs: T) where T: Numeric {
    for j in 0..<lhs.columns {
        let index = lhs.indexFinder(j)
        lhs.values[index] *= rhs
    }
}

// MARK: - Assignments
public func <<==<S: MatrixElement>(lhs: MatrixRow<S>, rhs: [S]) {
    assert(lhs.columns == rhs.count)
    
    for j in 0..<lhs.columns {
        let index = lhs.indexFinder(j)
        lhs.values[index] = rhs[j]
    }
}
