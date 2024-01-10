//
//  Matrix+popRow.swift
//  Matrix
//
//  Created by Reza on 1/10/24.
//

import Foundation

extension Matrix {
    @discardableResult
    public mutating func popRow(_ i: Int) -> RowType where RowType: Vector, RowType.Element == Element {
        assert(i >= 0 && i < rows)
        
        let outputPtr: UnsafeMutablePointer<RowType.Element> = .allocate(capacity: cols)
        outputPtr.initialize(from: valuesPtr.pointer + (cols * i), count: cols)
        let output: RowType = .init(SharedPointer(outputPtr), [1, cols])
        
        let newPtr: UnsafeMutablePointer<Element> = .allocate(capacity: capacity)
        // copy values up to row i
        if i != 0 {
            newPtr.initialize(from: valuesPtr.pointer, count: cols * i)
        }
        
        // copy values from row (i + 1) to (rows - 1)
        let sliceOffset: Int = cols * (i + 1)
        let sliceCount: Int = cols * (rows - i - 1)
        let newPtrOffset: Int = cols * i
        
        if sliceCount != 0 {
            (newPtr + newPtrOffset).initialize(from: valuesPtr.pointer + sliceOffset, count: sliceCount)
        }
        
        size = [size.rows - 1, cols]
        valuesPtr = .init(newPtr)
        return output
    }
}
