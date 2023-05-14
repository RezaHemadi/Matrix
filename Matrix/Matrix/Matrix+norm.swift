//
//  Matrix+norm.swift
//  ClothSimulation
//
//  Created by Reza on 1/16/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix where Element: FloatingPoint {
    public func norm() -> Element where Element == Double {
        var total: Element = .zero
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i]
            total += (value * value)
        }
        
        return Darwin.sqrt(total)
    }
    
    public func norm() -> Element where Element == Float {
        var total: Element = .zero
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i]
            total += (value * value)
        }
        
        return Darwin.sqrtf(total)
    }
    /*
    func norm() -> Element where Element == Float80 {
        var total: Element = .zero
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i]
            total += (value * value)
        }
        
        return Darwin.sqrtl(total)
    }*/
}
