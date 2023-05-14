//
//  Matrix+Normalize.swift
//  ClothSimulation
//
//  Created by Reza on 1/21/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public mutating func normalize() where Element == Double {
        let norm = self.norm()
        for i in 0..<size.count {
            valuesPtr.pointer[i] /= norm
        }
    }
    
    public mutating func normalize() where Element == Float {
        let norm = self.norm()
        for i in 0..<size.count {
            valuesPtr.pointer[i] /= norm
        }
    }
    /*
    mutating func normalize() where Element == Float80 {
        let norm = self.norm()
        for i in 0..<size.count {
            valuesPtr.pointer[i] /= norm
        }
    }*/
}
