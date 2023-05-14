//
//  VectorwiseOp.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct VectorwiseOp<V: Vector> {
    // MARK: - Properties
    public let valuePtr: SharedPointer<V.Element>
    
    /// each nested array contains offsets into valuePtr
    /// each element of the outer array is a row or column of the original matrix
    public let indices: [[Int]]
    
    // MARK: - Methods
    public func mean() -> V where V.Element: FloatingPoint {
        typealias S = V.Element
        
        var output: V = .init(indices.count)
        
        for i in 0..<indices.count {
            var sum: S = .zero
            
            for offset in indices[i] {
                sum += (valuePtr.pointer + offset).pointee
            }
            
            output[i] = sum / S(indices[i].count)
        }
        
        return output
    }
    
    public func sum() -> V where V.Element: AdditiveArithmetic {
        typealias S = V.Element
        
        let count = indices.count
        let size: MatrixSize = [V.Rows == 0 ? count : V.Rows, V.Cols == 0 ? count : V.Cols]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: count)
        
        for i in 0..<count {
            var sum: S = .zero
            for offset in indices[i] {
                sum += valuePtr.pointer[offset]
            }
            (pointer + i).initialize(to: sum)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func sum<V1: Vector>() -> V1 where V1.Element: AdditiveArithmetic, V1.Element == V.Element {
        typealias S = V.Element
        
        let count = indices.count
        let size: MatrixSize = [V.Rows == 0 ? count : V.Rows, V.Cols == 0 ? count : V.Cols]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: count)
        
        for i in 0..<count {
            var sum: S = .zero
            for offset in indices[i] {
                sum += valuePtr.pointer[offset]
            }
            (pointer + i).initialize(to: sum)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func minCoeff() -> V where V.Element: Comparable {
        typealias S = V.Element
        
        let count = indices.count
        let size: MatrixSize = [V.Rows == 0 ? count : V.Rows, V.Cols == 0 ? count : V.Cols]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: count)
        
        for i in 0..<count {
            var min: S = valuePtr.pointer[indices[i][0]]
            for j in 1..<indices[i].count {
                let value = valuePtr.pointer[indices[i][j]]
                if value < min {
                    min = value
                }
            }
            (pointer + i).initialize(to: min)
        }
        return .init(SharedPointer(pointer), size)
    }
    
    public func maxCoeff() -> V where V.Element: Comparable {
        typealias S = V.Element
        
        let count = indices.count
        let size: MatrixSize = [V.Rows == 0 ? count : V.Rows, V.Cols == 0 ? count : V.Cols]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: count)
        
        for i in 0..<count {
            var max: S = valuePtr.pointer[indices[i][0]]
            for j in 1..<indices[i].count {
                let value = valuePtr.pointer[indices[i][j]]
                if value > max {
                    max = value
                }
            }
            (pointer + i).initialize(to: max)
        }
        return .init(SharedPointer(pointer), size)
    }
}
