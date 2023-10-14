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
    public let values: [UnsafeMutablePointer<T>]
    public var count: Int { values.count }
    
    // MARK: - Methods
    public func norm() -> T where T == Double {
        var sum: T = .zero
        for i in 0..<count {
            let value = values[i].pointee
            sum += (value * value)
        }
        
        return Darwin.sqrt(sum)
    }
    
    public func norm() -> T where T == Float {
        var sum: T = .zero
        for i in 0..<count {
            let value = values[i].pointee
            sum += (value * value)
        }
        
        return Darwin.sqrtf(sum)
    }
    /*
    func norm() -> T where T == Float80 {
        var sum: T = .zero
        for i in 0..<count {
            let value = values[i].pointee
            sum += (value * value)
        }
        
        return Darwin.sqrtl(sum)
    }*/
    
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
    
    public func normalize() where T == Double {
        let norm = self.norm()
        for i in 0..<values.count {
            values[i].pointee /= norm
        }
    }
    
    public func normalize() where T == Float {
        let norm = self.norm()
        for i in 0..<values.count {
            values[i].pointee /= norm
        }
    }
}

extension MatrixRow: CustomStringConvertible {
    public var description: String {
        var output: String = ""
        for value in values {
            output += String(describing: value.pointee) + " "
        }
        
        return output
    }
}

extension MatrixRow: Equatable {
    public static func ==(lhs: MatrixRow, rhs: MatrixRow) -> Bool where T: Equatable {
        guard lhs.count == rhs.count else { return false }
        
        for i in 0..<lhs.count {
            if lhs.values[i].pointee != rhs.values[i].pointee { return false }
        }
        
        return true
    }
    
    public static func !=(lhs: MatrixRow, rhs: MatrixRow) -> Bool where T: Equatable {
        guard lhs.count == rhs.count else { return true }
        
        for i in 0..<lhs.count {
            if lhs.values[i].pointee != rhs.values[i].pointee { return true }
        }
        
        return false
    }
}
