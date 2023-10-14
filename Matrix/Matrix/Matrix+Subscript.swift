//
//  Matrix+Subscript.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public subscript(i: Int, j: Int) -> Element {
        get {
            assert((i >= 0 && j >= 0), "Invalid index")
            
            // element index when rows fill first
            let elementIndex = size.cols * i + j
            
            assert(i < rows && j < cols, "Index out of range")
                
            return valuesPtr.pointer[elementIndex]
        }
            
        set(newValue) {
            assert(i >= 0 && j >= 0, "invalid index")
            assert(i < rows, "Invalid row number")
            assert(j < cols, "Invalid column number")
                
            let elementIndex = size.cols * i + j
                
            valuesPtr.pointer[elementIndex] = newValue
        }
    }
    
    public subscript(_ i: Int) -> Element {
        get {
            assert(i < size.count)
            
            return valuesPtr.pointer[i]
        }
        
        set {
            assert(i < size.count)
            
            valuesPtr.pointer[i] = newValue
        }
    }
}
