//
//  MatrixBlock.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct MatrixBlock<T: MatrixElement> {
    // MARK: - Properties
    public let values: [UnsafeMutablePointer<T>]
    public let size: MatrixSize
    
    // MARK: - Methods
    public func array() -> MatrixArray<T> {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            (pointer + i).initialize(to: values[i].pointee)
        }
        
        return MatrixArray(valuesPtr: SharedPointer(pointer), size: size)
    }
}

extension MatrixBlock: CustomStringConvertible {
    public var description: String {
        var output: String = ""
            
        output += "["
        for i in 0..<size.rows {
            if i != 0 { output += " " }
            for j in 0..<size.cols {
                let index = elementIndex(i: i, j: j, size: size)
                output += String(describing: values[index].pointee)
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
