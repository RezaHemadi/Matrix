//
//  Matrix+CustomStringConvertible.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public var description: String {
        var output: String = ""
            
        output += "["
        for i in 0..<size.rows {
            if i != 0 { output += " " }
            for j in 0..<size.cols {
                output += String(describing: self[i, j])
                if j != (size.cols - 1) {
                    output += "\t"
                }
            }
                
            if i != (size.rows - 1) {
                output += "\n"
            }
        }
            
        output += "]"
        
        return output
    }
}
