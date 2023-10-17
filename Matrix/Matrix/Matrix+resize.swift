//
//  Matrix+resize.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    /// resizes the matrix without initializing entries
    public mutating func resize(_ rows: Int, _ cols: Int) {
        guard (rows != self.rows || cols != self.cols) else { return }
        
        if Self.Rows != 0 { assert(rows == Self.Rows) }
        if Self.Cols != 0 { assert(cols == Self.Cols) }
        
        size = [rows, cols]
        
        let n = size.count
        
        if n > capacity {
            // allocate new memory
            valuesPtr.pointer.deallocate()
            valuesPtr.pointer = .allocate(capacity: n)
            capacity = n
            valuesPtr.pointer.initialize(repeating: .init(), count: n)
        } else {
            valuesPtr.pointer.update(repeating: .init(), count: n)
        }
        
        /*
        valuesPtr.pointer.deallocate()
        valuesPtr.pointer = .allocate(capacity: size.count)
        valuesPtr.pointer.initialize(repeating: .init(), count: size.count)*/
    }
}
