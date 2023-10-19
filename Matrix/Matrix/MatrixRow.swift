//
//  MatrixRow.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct MatrixRow<T: MatrixElement> {
    // MARK: - Properties
    public let values: UnsafeMutablePointer<T>
    public let columns: Int
    public let indexFinder: UnaryIndexFinder
    
    // MARK: - Methods
    public subscript(_ j: Int) -> T {
        get {
            return values[indexFinder(j)]
        }
        set {
            values[indexFinder(j)] = newValue
        }
    }
    public func norm() -> T where T == Double {
        var sum: T = .zero
        for i in 0..<columns {
            let value = values[indexFinder(i)]
            sum += (value * value)
        }
        
        return Darwin.sqrt(sum)
    }
    
    public func norm() -> T where T == Float {
        var sum: T = .zero
        for i in 0..<columns {
            let value = values[indexFinder(i)]
            sum += (value * value)
        }
        
        return Darwin.sqrtf(sum)
    }
    
    public func maxCoeff() -> T where T: Comparable {
        assert(columns != 0)
        
        var max: T = values[indexFinder(0)]
        for i in 1..<columns {
            let value = values[indexFinder(i)]
            if value > max {
                max = value
            }
        }
        
        return max
    }
    
    public func minCoeff() -> T where T: Comparable {
        assert(columns != 0)
        
        var min: T = values[indexFinder(0)]
        for i in 1..<columns {
            let value = values[indexFinder(i)]
            if value < min {
                min = value
            }
        }
        
        return min
    }
    
    public func unaryExpr<V: Vector>(_ closure: (T) -> T) -> V where V.Element == T {
        let size: MatrixSize = [V.Rows == 1 ? 1 : columns,
                                V.Cols == 1 ? 1 : columns]
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: columns)
        
        for i in 0..<columns {
            let value = closure(values[indexFinder(i)])
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func setConstant(_ value: T) {
        for j in 0..<columns {
            values[indexFinder(j)] = value
        }
    }
    
    public func normalize() where T == Double {
        let norm = self.norm()
        for j in 0..<columns {
            values[indexFinder(j)] /= norm
        }
    }
    
    public func normalize() where T == Float {
        let norm = self.norm()
        for j in 0..<columns {
            values[indexFinder(j)] /= norm
        }
    }
}

extension MatrixRow: CustomStringConvertible {
    public var description: String {
        var output: String = ""
        for j in 0..<columns {
            output += String(describing: values[indexFinder(j)]) + " "
        }
        
        return output
    }
}

extension MatrixRow: Equatable {
    public static func ==(lhs: MatrixRow, rhs: MatrixRow) -> Bool where T: Equatable {
        guard lhs.columns == rhs.columns else { return false }
        
        for j in 0..<lhs.columns {
            if lhs[j] != rhs[j] { return false }
        }
        
        return true
    }
    
    public static func !=(lhs: MatrixRow, rhs: MatrixRow) -> Bool where T: Equatable {
        guard lhs.columns == rhs.columns else { return true }
        
        for j in 0..<lhs.columns {
            if lhs[j] != rhs[j] { return true }
        }
        
        return false
    }
}
