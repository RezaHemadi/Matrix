//
//  Matrix+reserveCapacity.swift
//  Matrix
//
//  Created by Reza on 10/16/23.
//

import Foundation

extension Matrix {
    public mutating func reserveCapacity(_ newCapacity: Int) {
        guard newCapacity > capacity else { return }
        
        // allocate new memory
        let newPtr: UnsafeMutablePointer<Element> = .allocate(capacity: newCapacity)
        capacity = newCapacity
        
        let n = size.count
        if n != 0 {
            newPtr.initialize(from: valuesPtr.pointer, count: n)
        }
        
        valuesPtr.pointer.deallocate()
        valuesPtr.pointer = newPtr
    }
}
