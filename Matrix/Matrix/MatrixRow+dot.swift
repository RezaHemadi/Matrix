//
//  MatrixRow+dot.swift
//  ClothSimulation
//
//  Created by Reza on 1/21/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension MatrixRow {
    public func dot(_ other: MatrixRow) -> T where T: Numeric {
        assert(columns == other.columns)
        
        var total: T = .zero
        for i in 0..<columns {
            let value = self[i] * other[i]
            total += value
        }
        
        return total
    }
}
