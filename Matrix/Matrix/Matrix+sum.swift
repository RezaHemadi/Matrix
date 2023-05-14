//
//  Matrix+sum.swift
//  ClothSimulation
//
//  Created by Reza on 1/16/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix where Element: AdditiveArithmetic {
    /// returns the sum of the coefficients
    public func sum() -> Element {
        var total: Element = .zero
        for i in 0..<size.count {
            total += valuesPtr.pointer[i]
        }
        
        return total
    }
}
