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
        assert(count == other.count)
        
        var total: T = .zero
        for i in 0..<count {
            let value = values[i].pointee * other.values[i].pointee
            total += value
        }
        
        return total
    }
}
