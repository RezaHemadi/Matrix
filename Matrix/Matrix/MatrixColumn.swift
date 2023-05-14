//
//  MatrixColumn.swift
//  ClothSimulation
//
//  Created by Reza on 1/12/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

/// can be used either as lvalue or rvalue
///  ravalue: assignment
///  lvalue: manipulate parent matrix
public struct MatrixColumn<T: MatrixElement> {
    // MARK: - Properties
    public var count: Int { values.count }
    public var values: [UnsafeMutablePointer<T>]
    
    // MARK: - subscripts
    public subscript(_ i: Int) -> T {
        get {
            assert(i < count)
            return values[i].pointee
        }
        set {
            assert(i < count)
            values[i].pointee = newValue
        }
    }
    
    // MARK: - Methods
    public func array() -> MatrixArray<T> {
        let size: MatrixSize = [count, 1]
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: count)
        pointer.initialize(from: values.map({ $0.pointee }), count: count)
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    public func maxCoeff() -> T where T: Comparable {
        assert(!values.isEmpty)
        
        var max: T = values[0].pointee
        for i in 1..<count {
            let value = values[i].pointee
            if value > max {
                max = value
            }
        }
        
        return max
    }
    
    public func minCoeff() -> T where T: Comparable {
        assert(!values.isEmpty)
        
        var min: T = values[0].pointee
        for i in 1..<count {
            let value = values[i].pointee
            if value < min {
                min = value
            }
        }
        
        return min
    }
    
    public func asDiagonal() -> Mat<T> {
        let size: MatrixSize = [count, count]
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.rows {
            for j in 0..<size.cols {
                let index = elementIndex(i: i, j: j, size: size)
                if (i == j) {
                    let value = values[i].pointee
                    (pointer + index).initialize(to: value)
                } else {
                    (pointer + index).initialize(to: .init())
                }
            }
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func unaryExpr<V: Vector>(_ closure: (T) -> T) -> V where V.Element == T {
        let size: MatrixSize = [V.Rows == 1 ? 1 : count,
                                V.Cols == 1 ? 1 : count]
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: count)
        
        for i in 0..<count {
            let value = closure(values[i].pointee)
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func setConstant(_ value: T) {
        values.forEach({ $0.pointee = value })
    }
}

extension MatrixColumn: CustomStringConvertible {
    public var description: String {
        var output: String = ""
        
        for value in values {
            output += String(describing: value.pointee) + " "
        }
        
        return output
    }
}
