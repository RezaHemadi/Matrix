//
//  Matrix+Rowise().swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix where ColType: Vector, ColType.Element == Element {
    public func rowise() -> VectorwiseOp<ColType> {
        var indices: [[Int]] = []
        indices.reserveCapacity(rows)
        
        for i in 0..<rows {
            var rowIndices: [Int] = []
            rowIndices.reserveCapacity(cols)
            
            for j in 0..<cols {
                let index = elementIndex(i: i, j: j, size: size)
                rowIndices.append(index)
            }
            
            indices.append(rowIndices)
        }
        
        return .init(valuePtr: valuesPtr, indices: indices)
    }
}
