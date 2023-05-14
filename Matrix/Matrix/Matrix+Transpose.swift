//
//  Matrix+Transpose.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public func transpose() -> TransposeType where TransposeType.Element == Element {
        var output: TransposeType = .init(cols, rows)
        
        for i in 0..<size.rows {
            for j in 0..<size.cols {
                output[j, i] = self[i, j]
            }
        }
        
        return output
    }
}
