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

// Matrix <<== [Element]
public func <<==<S: MatrixElement, M: Matrix>(lhs: inout M, rhs: [S]) where M.Element == S {
    assert(rhs.count <= lhs.size.count)
    
    lhs.valuesPtr.pointer.initialize(from: rhs, count: rhs.count)
}

// Matrix <<== [MatrixRow]
public func <<==<S: MatrixElement, M: Matrix>(lhs: inout M, rhs: [MatrixRow<S>]) where M.Element == S {
    let rhsCount: Int = rhs.map({$0.count}).reduce(0, +)
    assert(rhsCount <= lhs.size.count)
    
    var values: [UnsafeMutablePointer<S>] = rhs.flatMap({$0.values})
    
    for i in 0..<values.count {
        (lhs.valuesPtr.pointer + i).initialize(to: values[i].pointee)
    }
}

// MatrixRow <<== MatrixBlock
public func <<==<S: MatrixElement>(lhs: MatrixRow<S>, rhs: MatrixBlock<S>) {
    assert(rhs.size.cols == lhs.count)
    assert(rhs.size.rows == 1)
    
    for i in 0..<lhs.count {
        lhs.values[i].pointee = rhs.values[i].pointee
    }
}

// MatrixBlock <<== [Element]
public func <<==<S: MatrixElement>(lhs: MatrixBlock<S>, rhs: [S]) {
    assert(lhs.size.count == rhs.count)
    
    for i in 0..<lhs.values.count {
        lhs.values[i].pointee = rhs[i]
    }
}

// MatrixBlock <<== MatrixBlock
public func <<==<S: MatrixElement>(lhs: MatrixBlock<S>, rhs: MatrixBlock<S>) {
    assert(lhs.size == rhs.size)
    
    for i in 0..<lhs.size.count {
        lhs.values[i].pointee = rhs.values[i].pointee
    }
}

// MatrixBlock <<== [MatrixBlock]
public func <<==<S: MatrixElement>(lhs: MatrixBlock<S>, rhs: [MatrixBlock<S>]) {
    assert(lhs.size.count == (rhs.map({$0.size.count}).reduce(0, +)))
    
    let flatRhs = rhs.flatMap({$0.values})
    
    for i in 0..<lhs.size.count {
        lhs.values[i].pointee = flatRhs[i].pointee
    }
}

// Matrix <<== [Matrix]
public func <<==<M1: Matrix, M2: Matrix>(lhs: inout M1, rhs: [M2]) where M1.Element == M2.Element {
    assert(lhs.size.count >= rhs.map({$0.size.count}).reduce(0, +))
    
    // start writing elements at top left corner
    var curRowIdx: Int = 0
    var curColIdx: Int = 0
    let maxRowIdx: Int = lhs.rows - 1
    let maxColIdx: Int = lhs.cols - 1
    
    for t in 0..<rhs.count {
        let m = rhs[t]
        // Make sure lhs has enough room for current matrix
        let availableCols: Int = (maxColIdx - curColIdx) + 1
        let availableRows: Int = (maxRowIdx - curRowIdx) + 1
        
        assert(m.rows <= availableRows)
        assert(m.cols <= availableCols)
        
        // write values to lhs
        for i in 0..<m.rows {
            for j in 0..<m.cols {
                lhs[curRowIdx + i, curColIdx + j] = m[i, j]
            }
        }
        
        if (t != rhs.count - 1) {
            // move curRowIdx and curColIdx to new positions
            curRowIdx += m.rows
            curColIdx += m.cols
            
            if (curRowIdx > maxRowIdx) {
                curRowIdx = 0
                if (curColIdx > maxColIdx) {
                    fatalError("ran out of cols!")
                }
            }
            
            if (curColIdx > maxColIdx) {
                curColIdx = 0
                if (curRowIdx > maxRowIdx) {
                    fatalError("ran out of rows!")
                }
            }
        }
    }
}

// MatrixBlock <<== [Matrix]
public func <<==<S: MatrixElement, M: Matrix>(lhs: MatrixBlock<S>, rhs: [M]) where M.Element == S {
    assert(lhs.size.count >= rhs.map({$0.size.count}).reduce(0, +))
    
    // start writing elements at top left corner
    var curRowIdx: Int = 0
    var curColIdx: Int = 0
    let maxRowIdx: Int = lhs.size.rows - 1
    let maxColIdx: Int = lhs.size.cols - 1
    
    for t in 0..<rhs.count {
        let m = rhs[t]
        // Make sure lhs has enough room for current matrix
        let availableCols: Int = (maxColIdx - curColIdx) + 1
        let availableRows: Int = (maxRowIdx - curRowIdx) + 1
        
        assert(m.rows <= availableRows)
        assert(m.cols <= availableCols)
        
        // write values to lhs
        for i in 0..<m.rows {
            for j in 0..<m.cols {
                lhs[curRowIdx + i, curColIdx + j] = m[i, j]
            }
        }
        
        if (t != rhs.count - 1) {
            // move curRowIdx and curColIdx to new positions
            curRowIdx += m.rows
            curColIdx += m.cols
            
            if (curRowIdx > maxRowIdx) {
                curRowIdx = 0
                if (curColIdx > maxColIdx) {
                    fatalError("ran out of cols!")
                }
            }
            
            if (curColIdx > maxColIdx) {
                curColIdx = 0
                if (curRowIdx > maxRowIdx) {
                    fatalError("ran out of rows!")
                }
            }
        }
    }
}
