//
//  MatrixColumn+Operators.swift
//  ClothSimulation
//
//  Created by Reza on 1/15/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

// MARK: - Addition
public func +<S: MatrixElement & AdditiveArithmetic>(lhs: MatrixColumn<S>, rhs: MatrixColumn<S>) -> Vec<S> {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [lhs.count, 1]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = lhs.values[i].pointee + rhs.values[i].pointee
        (pointer + i).pointee = value
    }
    
    return Vec<S>(SharedPointer(pointer), size)
}

public func -<S: MatrixElement & SignedNumeric>(lhs: MatrixColumn<S>, rhs: MatrixColumn<S>) -> Vec<S> {
    assert(lhs.count == rhs.count)
    
    let size: MatrixSize = [lhs.count, 1]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = lhs.values[i].pointee - rhs.values[i].pointee
        (pointer + i).pointee = value
    }
    
    return Vec<S>(SharedPointer(pointer), size)
}

public func +<S: MatrixElement & AdditiveArithmetic, M: Matrix>(lhs: M, rhs: MatrixColumn<S>) -> M where M.Element == S {
    assert(lhs.rows == 1 && lhs.cols == rhs.count)
    
    let n = rhs.count
    let valuesPtr: UnsafeMutablePointer<S> = .allocate(capacity: n)
    
    for i in 0..<n {
        let value: S = lhs[i, 0] + rhs[i]
        (valuesPtr + i).initialize(to: value)
    }
    
    return .init(.init(valuesPtr), lhs.size)
}

public func +<S: MatrixElement & AdditiveArithmetic, M: Matrix>(lhs: MatrixColumn<S>, rhs: M) -> M where M.Element == S {
    assert(rhs.rows == 1 && lhs.count == rhs.cols)
    
    let n = lhs.count
    let valuesPtr: UnsafeMutablePointer<S> = .allocate(capacity: n)
    
    for i in 0..<n {
        let value: S = rhs[i, 0] + lhs[i]
        (valuesPtr + i).initialize(to: value)
    }
    
    return .init(.init(valuesPtr), rhs.size)
}

public func +=<S:MatrixElement & AdditiveArithmetic>(lhs: MatrixColumn<S>, rhs: S) {
    for i in 0..<lhs.values.count {
        lhs.values[i].pointee += rhs
    }
}

// MARK: - Division
public func /=<T: MatrixElement & FloatingPoint>(lhs: MatrixColumn<T>, rhs: T) {
    for i in 0..<lhs.count {
        lhs.values[i].pointee /= rhs
    }
}

// MARK: - Assignment
public func <<==<T: MatrixElement>(lhs: MatrixColumn<T>, rhs: MatrixBlock<T>) {
    /// assert right hand block is a column block
    assert(rhs.size.cols == 1)
    
    /// assert number of elements are equal on both sides
    assert(lhs.count == rhs.size.rows)
    
    // loop over elements to assign
    for i in 0..<lhs.count {
        lhs.values[i].pointee = rhs.values[i].pointee
    }
}

public func <<==<S: MatrixElement>(lhs: MatrixColumn<S>, rhs: [S]) {
    assert(lhs.count == rhs.count, "array count does not match column count")
    
    for i in 0..<lhs.count {
        lhs.values[i].pointee = rhs[i]
    }
}
