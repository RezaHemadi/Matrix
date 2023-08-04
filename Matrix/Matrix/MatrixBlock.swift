//
//  MatrixBlock.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public class MatrixBlock<T: MatrixElement> {
    // MARK: - Properties
    public let values: [UnsafeMutablePointer<T>]
    public let size: MatrixSize
    
    // MARK: - Initializer
    required init(values: [UnsafeMutablePointer<T>], size: MatrixSize) {
        self.values = values
        self.size = size
    }
    
    // MARK: - Methods
    public subscript(i: Int, j: Int) -> T {
        get {
            guard (i >= 0 && j >= 0) else { fatalError("Invalid index") }
            
            // element index when using row major format
            let elementIndex = size.cols * i + j
            guard (i < size.rows && j < size.cols) else { fatalError("Index out of range") }
            
            return values[elementIndex].pointee
        }
        
        set (newValue) {
            guard (i >= 0 && j >= 0) else { fatalError("Invalid index") }
            guard (i < size.rows) else { fatalError("Invalid row number") }
            guard (j < size.cols) else { fatalError("Invalid column number") }
            
            // element index when using row major format
            let elementIndex = size.cols * i + j
            
            values[elementIndex].pointee = newValue
        }
    }
    
    public func transpose() -> Self {
        let size = MatrixSize(self.size.cols, self.size.rows)
        
        var values: [UnsafeMutablePointer<T>?] = .init(repeating: nil, count: size.count)
        values.reserveCapacity(self.values.count)
        
        for i in 0..<self.size.rows {
            for j in 0..<self.size.cols {
                let oldIndex = elementIndex(i: i, j: j, size: self.size)
                let newIndex = elementIndex(i: j, j: i, size: size)
                values[newIndex] = self.values[oldIndex]
            }
        }
        return .init(values: values.compactMap({$0}), size: size)
    }
    
    public func array() -> MatrixArray<T> {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            (pointer + i).initialize(to: values[i].pointee)
        }
        
        return MatrixArray(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    public func squaredNorm() -> T where T: Numeric {
        var sum: T = .zero
        
        for i in 0..<values.count {
            let value = values[i].pointee
            sum += (value * value)
        }
        
        return sum
    }
    
    /// Set all elements of this block to zero
    public func setZero() where T: ExpressibleByIntegerLiteral {
        values.forEach({ $0.pointee = 0 })
    }
    
    public func col(_ j: Int) -> MatrixColumn<T> {
        assert(j < size.cols)
        
        var pointers: [UnsafeMutablePointer<T>] = []
        
        for i in 0..<size.rows {
            let elementIndex = elementIndex(i: i, j: j, size: size)
            pointers.append(values[elementIndex])
        }
        
        return .init(values: pointers)
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
