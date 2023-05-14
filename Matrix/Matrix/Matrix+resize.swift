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
        if Self.Rows != 0 { assert(rows == Self.Rows) }
        if Self.Cols != 0 { assert(cols == Self.Cols) }
        
        size = [rows, cols]
        valuesPtr.pointer.deallocate()
        valuesPtr.pointer = .allocate(capacity: size.count)
        //valuesPtr.pointer.initialize(repeating: .init(), count: size.count)
    }
}
