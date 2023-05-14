//
//  MatrixArray+rowwise.swift
//  ClothSimulation
//
//  Created by Reza on 1/22/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension MatrixArray {
    func rowise() -> VectorwiseOp<Vec<T>> {
        var indices: [[Int]] = []
        indices.reserveCapacity(size.rows)
        
        for i in 0..<size.rows {
            var rowIndices: [Int] = []
            
            for j in 0..<size.cols {
                let index = elementIndex(i: i, j: j, size: size)
                rowIndices.append(index)
            }
            indices.append(rowIndices)
        }
        return .init(valuePtr: valuesPtr, indices: indices)
    }
}
