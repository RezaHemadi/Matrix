//
//  Matrix+removeRowsAt.swift
//  Matrix
//
//  Created by Reza on 1/11/24.
//

import Foundation

extension Matrix {
    mutating public func removeRowsAt(_ range: Range<Int>) {
        assert(range.lowerBound >= 0 && range.upperBound <= rows)
        
        let newPtr: UnsafeMutablePointer<Element> = .allocate(capacity: capacity)
        // copy values up to lowerbound
        if range.lowerBound != 0 {
            newPtr.initialize(from: valuesPtr.pointer, count: cols * range.lowerBound)
        }
        
        // copy values from row (range.upperbound) to (rows - 1)
        let sliceOffset: Int = cols * (range.upperBound)
        let sliceCount: Int = cols * (rows - range.upperBound)
        let newPtrOffset: Int = cols * range.lowerBound
        
        if sliceCount != 0 {
            (newPtr + newPtrOffset).initialize(from: valuesPtr.pointer + sliceOffset, count: sliceCount)
        }
        
        size = [size.rows - range.count, cols]
        valuesPtr = .init(newPtr)
    }
}
