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
            guard (i >= 0 && j >= 0) else { fatalError("Invalid index") }
            // element index when cols fill first
            //let elementIndex = j * size.rows + i
            
            // element index when rows fill first
            let elementIndex = size.cols * i + j
            
            guard (i < rows && j < cols) else { fatalError("Index out of range") }
                
            return valuesPtr.pointer[elementIndex]
        }
            
        set(newValue) {
            guard (i >= 0 && j >= 0) else { fatalError("Invalid index") }
            guard (i < rows) else { fatalError("Invalid row number") }
            guard (j < cols) else { fatalError("Invalid column number")}
                
            //let elementIndex = j * size.rows + i
            let elementIndex = size.cols * i + j
                
            valuesPtr.pointer[elementIndex] = newValue
        }
    }
    
    public subscript(_ i: Int) -> Element {
        get {
            valuesPtr.pointer[i]
        }
        
        set {
            valuesPtr.pointer[i] = newValue
        }
    }
}
