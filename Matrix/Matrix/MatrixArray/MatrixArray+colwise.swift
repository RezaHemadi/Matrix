//
//  MatrixArray+colwise.swift
//  ClothSimulation
//
//  Created by Reza on 1/22/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension MatrixArray {
    public func colwise() -> VectorwiseOp<RVec<T>> {
        var indices: [[Int]] = []
        indices.reserveCapacity(size.cols)
        
        for j in 0..<size.cols {
            var colIndices: [Int] = []
            colIndices.reserveCapacity(size.rows)
            
            for i in 0..<size.rows {
                let index = elementIndex(i: i, j: j, size: size)
                colIndices.append(index)
            }
            indices.append(colIndices)
        }
        
        return .init(valuePtr: valuesPtr, indices: indices)
    }
}
