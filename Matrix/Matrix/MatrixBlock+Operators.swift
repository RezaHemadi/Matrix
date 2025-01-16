//
//  MatrixBlock+Operators.swift
//  ClothSimulation
//
//  Created by Reza on 1/25/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public func +<S: MatrixElement & AdditiveArithmetic, M: Matrix>(lhs: MatrixBlock<S>, rhs: M) -> M where M.Element == S {
    assert(lhs.rows == rhs.rows && lhs.cols == rhs.cols)
    
    let size: MatrixSize = rhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.rows {
        for j in 0..<size.cols {
            let index = elementIndex(i: i, j: j, size: rhs.size)
            (pointer + index).initialize(to: lhs[i, j] + rhs.valuesPtr.pointer[index])
        }
    }
    
    return .init(SharedPointer(pointer), size)
}

public func +=<S: MatrixElement & AdditiveArithmetic, M: Matrix>(lhs: MatrixBlock<S>, rhs: M) where M.Element == S {
    assert(lhs.rows == rhs.rows && lhs.cols == rhs.cols)
    for i in 0..<lhs.rows {
        for j in 0..<lhs.cols {
            lhs[i, j] += rhs[i, j]
        }
    }
}

public func +=<S: MatrixElement & AdditiveArithmetic>(lhs: MatrixBlock<S>, rhs: MatrixBlock<S>) {
    assert(lhs.rows == rhs.rows && lhs.cols == rhs.cols)
    
    for i in 0..<lhs.rows {
        for j in 0..<lhs.cols {
            lhs[i, j] += rhs[i, j]
        }
    }
}

public func /=<S: MatrixElement & FloatingPoint>(lhs: MatrixBlock<S>, rhs: S) {
    for i in 0..<(lhs.rows * lhs.cols) {
        lhs.values[i] /= rhs
    }
}
