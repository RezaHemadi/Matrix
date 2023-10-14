//
//  Matrix+MinCoeff.swift
//  ClothSimulation
//
//  Created by Reza on 1/22/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix where Element: Comparable {
    public func minCoeff() -> Element {
        assert(size.count != 0)
        
        var min: Element = valuesPtr.pointer[0]
        if size.count > 1 {
            for i in 1..<size.count {
                let value = valuesPtr.pointer[i]
                if value < min {
                    min = value
                }
            }
            
            return min
        }
        return min
    }
}
