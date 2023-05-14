//
//  Matrix+squaredNorm.swift
//  ClothSimulation
//
//  Created by Reza on 1/15/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix where Element: Numeric {
    public func squaredNorm() -> Element {
        var sum: Element = .zero
        
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i]
            sum += (value * value)
        }
        
        return sum
    }
}
