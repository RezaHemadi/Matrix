//
//  Matrix+CustomStringConvertible.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation
/*
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
}*/

extension Matrix {
    public var description: String {
        var width: Int = 0
        var nums: [String] = []
        nums.reserveCapacity(size.count)
        var output: String = ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 2
        
        for i in 0..<rows {
            for j in 0..<cols {
                nums.append(formatter.string(for: self[i, j])!)
            }
        }
        
        width = nums.max(by: {$0.count < $1.count})!.count + 2
        
        output += "["
        for i in 0..<size.rows {
            if i != 0 { output += " " }
            for j in 0..<size.cols {
                //output += String(describing: self[i, j])
                let cur = formatter.string(for: self[i, j])!
                output += cur
                if j != (size.cols - 1) {
                    //output += "\t"
                    let length = width - cur.count
                    if length != 0 {
                        for _ in 0..<length {
                            output += " "
                        }
                    }
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
