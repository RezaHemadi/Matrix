//
//  Matrix+Colwise.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix where RowType: Vector, RowType.Element == Element {
    public func colwise() -> VectorwiseOp<RowType> {
        var indices: [[Int]] = []
        indices.reserveCapacity(cols)
        
        for j in 0..<cols {
            var colIndices: [Int] = []
            colIndices.reserveCapacity(rows)
            
            for i in 0..<rows {
                let index = elementIndex(i: i, j: j, size: size)
                colIndices.append(index)
            }
            
            indices.append(colIndices)
        }
        
        return .init(valuePtr: valuesPtr, indices: indices)
    }
}
