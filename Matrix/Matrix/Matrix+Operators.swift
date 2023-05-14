//
//  Matrix+Operators.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

infix operator <<== : AssignmentPrecedence

// Assignment to matrix column
public func <<==<M: Matrix>(lhs: MatrixColumn<M.Element>, rhs: M) {
    assert(rhs.cols == 1)
    assert(lhs.count == rhs.rows)
    
    for i in 0..<rhs.rows {
        lhs.values[i].pointee = rhs[i, 0]
    }
}

// MatrixColmn <<== MatrixColumn
public func <<==<S: MatrixElement>(lhs: MatrixColumn<S>, rhs: MatrixColumn<S>) {
    assert(lhs.count == rhs.count)
    
    for i in 0..<rhs.count {
        lhs.values[i].pointee = rhs.values[i].pointee
    }
}

// MatrixRow <<== MatrixRow
public func <<==<S: MatrixElement>(lhs: MatrixRow<S>, rhs: MatrixRow<S>) {
    assert(lhs.count == rhs.count)
    
    for i in 0..<rhs.count {
        lhs.values[i].pointee = rhs.values[i].pointee
    }
}

// Assignment to matrix row
public func <<==<M: Matrix>(lhs: MatrixRow<M.Element>, rhs: M) {
    assert(lhs.count == rhs.size.count)
    assert(rhs.rows == 1 || rhs.cols == 1)
    
    /*
    for i in 0..<rhs.cols {
        lhs.values[i].pointee = rhs[0, i]
    }*/
    for i in 0..<lhs.count {
        lhs.values[i].pointee = rhs.valuesPtr.pointer[i]
    }
}

// Assignment to matrix block
public func <<==<M: Matrix>(lhs: MatrixBlock<M.Element>, rhs: M) {
    assert(lhs.size == rhs.size)
    
    for j in 0..<rhs.cols {
        for i in 0..<rhs.rows {
            let index = elementIndex(i: i, j: j, size: lhs.size)
            lhs.values[index].pointee = rhs[i, j]
        }
    }
}

// MatrixArray to Matrix Assignment
public func <<==<M: Matrix, S: MatrixElement>(lhs: inout M, rhs: MatrixArray<S>) where M.Element == S {
    let size = rhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    pointer.initialize(from: rhs.valuesPtr.pointer, count: size.count)
    
    lhs = .init(SharedPointer(pointer), rhs.size)
}

// MatrixBlock <<== MatrixColumn
public func <<==<S: MatrixElement>(lhs: MatrixBlock<S>, rhs: MatrixColumn<S>) {
    assert(lhs.size.count == rhs.count)
    assert(lhs.size.rows == 1 || lhs.size.cols == 1)
    
    for i in 0..<lhs.size.count {
        lhs.values[i].pointee = rhs.values[i].pointee
    }
}

// MatrixBlock <<== MatrixRow
public func <<==<S: MatrixElement>(lhs: MatrixBlock<S>, rhs: MatrixRow<S>) {
    assert(lhs.size.count == rhs.count)
    assert(lhs.size.rows == 1 || lhs.size.cols == 1)
    
    for i in 0..<lhs.size.count {
        lhs.values[i].pointee = rhs.values[i].pointee
    }
}

// MatrixBlock <<== MatrixArray
public func <<==<S: MatrixElement>(lhs: MatrixBlock<S>, rhs: MatrixArray<S>) {
    assert(lhs.size == rhs.size)
    
    for i in 0..<lhs.size.count {
        lhs.values[i].pointee = rhs.valuesPtr.pointer[i]
    }
}

// MatrixColumn <<== MatrixArray
public func <<==<S: MatrixElement>(lhs: MatrixColumn<S>, rhs: MatrixArray<S>) {
    assert(lhs.count == rhs.size.count)
    
    for i in 0..<lhs.count {
        lhs.values[i].pointee = rhs.valuesPtr.pointer[i]
    }
}
