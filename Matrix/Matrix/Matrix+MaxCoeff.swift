//
//  Matrix+MaxCoeff.swift
//  ClothSimulation
//
//  Created by Reza on 1/22/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix where Element: Comparable {
    public func maxCoeff() -> Element {
        assert(size.count != 0)
        
        var max: Element = valuesPtr.pointer[0]
        if size.count > 1 {
            for i in 1..<size.count {
                let value = valuesPtr.pointer[i]
                if value > max {
                    max = value
                }
            }
            
            return max
        }
        return max
    }
}
