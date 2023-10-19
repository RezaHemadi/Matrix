//
//  MatrixColumn.swift
//  ClothSimulation
//
//  Created by Reza on 1/12/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public typealias UnaryIndexFinder = (Int) -> Int

/// can be used either as lvalue or rvalue
///  ravalue: assignment
///  lvalue: manipulate parent matrix
public struct MatrixColumn<T: MatrixElement> {
    // MARK: - Properties
    public let rows: Int
    public let values: UnsafeMutablePointer<T>
    public let indexFinder: UnaryIndexFinder
    
    // MARK: - subscripts
    public subscript(_ i: Int) -> T {
        get {
            assert(i < rows && i >= 0, "invalid index")
            
            return values[indexFinder(i)]
            
        }
        set {
            assert(i < rows && i >= 0, "invalid index")
            values[indexFinder(i)] = newValue
        }
    }
    
    // MARK: - Methods
    public func maxCoeff() -> T where T: Comparable {
        assert(rows != 0)
        
        var max: T = values[indexFinder(0)]
        for i in 1..<rows {
            let value = values[indexFinder(i)]
            if value > max {
                max = value
            }
        }
        
        return max
    }
    
    public func minCoeff() -> T where T: Comparable {
        assert(rows != 0)
        
        var min: T = values[indexFinder(0)]
        for i in 1..<rows {
            let value = values[indexFinder(i)]
            if value < min {
                min = value
            }
        }
        
        return min
    }
    
    public func asDiagonal() -> Mat<T> {
        let size: MatrixSize = [rows, rows]
        let count = size.count
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: count)
        pointer.initialize(repeating: .init(), count: count)
        
        for i in 0..<rows {
            let targetIndex = size.cols * i + i
            pointer[targetIndex] = values[indexFinder(i)]
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func unaryExpr<V: Vector>(_ closure: (T) -> T) -> V where V.Element == T {
        let size: MatrixSize = [V.Rows == 1 ? 1 : rows,
                                V.Cols == 1 ? 1 : rows]
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: rows)
        
        for i in 0..<rows {
            let value = closure(values[indexFinder(i)])
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func setConstant(_ value: T) {
        for i in 0..<rows {
            values[indexFinder(i)] = value
        }
    }
}

extension MatrixColumn: CustomStringConvertible {
    public var description: String {
        var output: String = ""
        
        for i in 0..<rows {
            output += String(describing: values[indexFinder(i)]) + " "
        }
        
        return output
    }
}
