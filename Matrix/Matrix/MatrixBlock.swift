//
//  MatrixBlock.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public typealias IndexFinder = (Int, Int) -> Int

public class MatrixBlock<T: MatrixElement> {
    // MARK: - Properties
    public let values: UnsafeMutablePointer<T>
    public let indexFinder: IndexFinder
    public let rows: Int
    public let cols: Int
    
    // MARK: - Initializer
    required init(values: UnsafeMutablePointer<T>, indexFinder: @escaping IndexFinder, rows: Int, cols: Int) {
        self.values = values
        self.indexFinder = indexFinder
        self.rows = rows
        self.cols = cols
    }
    
    // MARK: - Methods
    public subscript(i: Int, j: Int) -> T {
        get {
            assert(i >= 0 && j >= 0, "invalid index")
            
            // element index when using row major format
            let index = indexFinder(i, j)
            return values[index]
        }
        
        set (newValue) {
            assert(i >= 0 && j >= 0, "invalid index")
            // element index when using row major format
            let index = indexFinder(i, j)
            
            values[index] = newValue
        }
    }
    
    public func array() -> MatrixArray<T> {
        let size: MatrixSize = [rows, cols]
        let ptr: UnsafeMutablePointer<T> = .allocate(capacity: rows * cols)
        
        for i in 0..<rows {
            for j in 0..<cols {
                let index = elementIndex(i: i, j: j, size: size)
                (ptr + index).initialize(to: self[i, j])
            }
        }
        
        return .init(valuesPtr: SharedPointer(ptr), size: size)
    }
    
    public func squaredNorm() -> T where T: Numeric {
        var sum: T = .zero
        
        for i in 0..<rows {
            for j in 0..<cols {
                let index = indexFinder(i, j)
                let value = values[index]
                sum += (value * value)
            }
        }
        return sum
    }
    
    /// Set all elements of this block to zero
    public func setZero() where T: ExpressibleByIntegerLiteral {
        for i in 0..<rows {
            for j in 0..<cols {
                values[indexFinder(i, j)] = 0
            }
        }
    }
}

extension MatrixBlock: CustomStringConvertible {
    public var description: String {
        var output: String = ""
            
        output += "["
        for i in 0..<rows {
            if i != 0 { output += " " }
            for j in 0..<cols {
                let index = indexFinder(i, j)
                output += String(describing: values[index])
                if j != (cols - 1) {
                    output += "\t"
                }
            }
                
            if i != (rows - 1) {
                output += "\n"
            }
        }
            
        output += "]"
        
        return output
    }
}
