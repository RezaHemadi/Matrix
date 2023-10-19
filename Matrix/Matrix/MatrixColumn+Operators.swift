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
    assert(lhs.rows == rhs.rows)
    
    let size: MatrixSize = [lhs.rows, 1]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        (pointer + i).pointee = lhs[i] + rhs[i]
    }
    
    return Vec<S>(SharedPointer(pointer), size)
}

public func -<S: MatrixElement & SignedNumeric>(lhs: MatrixColumn<S>, rhs: MatrixColumn<S>) -> Vec<S> {
    assert(lhs.rows == rhs.rows)
    
    let size: MatrixSize = [lhs.rows, 1]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        (pointer + i).pointee = lhs[i] - rhs[i]
    }
    
    return Vec<S>(SharedPointer(pointer), size)
}

public func +<S: MatrixElement & AdditiveArithmetic, M: Matrix>(lhs: M, rhs: MatrixColumn<S>) -> M where M.Element == S {
    assert(lhs.cols == 1 && lhs.rows == rhs.rows)
    
    let n = rhs.rows
    let valuesPtr: UnsafeMutablePointer<S> = .allocate(capacity: n)
    
    for i in 0..<n {
        let value: S = lhs[i, 0] + rhs[i]
        (valuesPtr + i).initialize(to: value)
    }
    
    return .init(.init(valuesPtr), lhs.size)
}

public func +<S: MatrixElement & AdditiveArithmetic, M: Matrix>(lhs: MatrixColumn<S>, rhs: M) -> M where M.Element == S {
    assert(rhs.cols == 1 && lhs.rows == rhs.rows)
    
    let n = lhs.rows
    let valuesPtr: UnsafeMutablePointer<S> = .allocate(capacity: n)
    
    for i in 0..<n {
        let value: S = rhs[i, 0] + lhs[i]
        (valuesPtr + i).initialize(to: value)
    }
    
    return .init(.init(valuesPtr), rhs.size)
}

public func +=<S:MatrixElement & AdditiveArithmetic>(lhs: MatrixColumn<S>, rhs: S) {
    for i in 0..<lhs.rows {
        let index = lhs.indexFinder(i)
        lhs.values[index] += rhs
    }
}

// MARK: - Division
public func /=<T: MatrixElement & FloatingPoint>(lhs: MatrixColumn<T>, rhs: T) {
    for i in 0..<lhs.rows {
        let index = lhs.indexFinder(i)
        lhs.values[index] /= rhs
    }
}

// MARK: - Assignment
public func <<==<T: MatrixElement>(lhs: MatrixColumn<T>, rhs: MatrixBlock<T>) {
    /// assert right hand block is a column block
    assert(rhs.cols == 1)
    
    /// assert number of elements are equal on both sides
    assert(lhs.rows == rhs.rows)
    
    // loop over elements to assign
    for i in 0..<lhs.rows {
        let index = lhs.indexFinder(i)
        lhs.values[index] = rhs[i, 0]
    }
}

public func <<==<S: MatrixElement>(lhs: MatrixColumn<S>, rhs: [S]) {
    assert(lhs.rows == rhs.count, "array count does not match column count")
    
    for i in 0..<lhs.rows {
        let index = lhs.indexFinder(i)
        lhs.values[index] = rhs[i]
        //lhs.values[i].pointee = rhs[i]
    }
}
