//
//  VectorwideOp+Operators.swift
//  ClothSimulation
//
//  Created by Reza on 1/20/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension VectorwiseOp {
    // MARK: - Addition
    public static func +<M: Matrix, T: Vector>(lhs: VectorwiseOp, rhs: T) -> M where T.Element == M.Element, T.Element: AdditiveArithmetic, T.Element == V.Element {
        typealias S = T.Element
        assert(lhs.indices[0].count == rhs.count)
        
        let size: MatrixSize = [rhs.rows == 1 ? lhs.indices.count : rhs.rows,
                                rhs.cols == 1 ? lhs.indices.count : rhs.cols]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
        
        if rhs.rows == 1 {
            // row vector
            // outer index in indices correspond to row
            // inner index in indices correspoind to col
            for j in 0..<size.cols {
                for i in 0..<size.rows {
                    let index = elementIndex(i: i, j: j, size: size)
                    let lhsIndex = lhs.indices[i][j]
                    let value = lhs.valuePtr.pointer[lhsIndex] + rhs[j]
                    (pointer + index).initialize(to: value)
                }
            }
        } else {
            // column vector
            // outer indices correspond to col
            // inner indices correspond to row
            for j in 0..<size.cols {
                for i in 0..<size.rows {
                    let index = elementIndex(i: i, j: j, size: size)
                    let lhsIndex = lhs.indices[j][i]
                    let value = lhs.valuePtr.pointer[lhsIndex] + rhs[i]
                    (pointer + index).initialize(to: value)
                }
            }
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public static func +<M: Matrix, T: Vector>(lhs: T, rhs: VectorwiseOp) -> M where T.Element == M.Element, T.Element: AdditiveArithmetic, T.Element == V.Element {
        typealias S = T.Element
        assert(rhs.indices[0].count == lhs.count)
        
        let size: MatrixSize = [lhs.rows == 1 ? rhs.indices.count : lhs.rows,
                                lhs.cols == 1 ? rhs.indices.count : lhs.cols]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
        
        if lhs.rows == 1 {
            // row vector
            // outer index in indices correspond to row
            // inner index in indices correspoind to col
            for j in 0..<size.cols {
                for i in 0..<size.rows {
                    let index = elementIndex(i: i, j: j, size: size)
                    let rhsIndex = rhs.indices[i][j]
                    let value = rhs.valuePtr.pointer[rhsIndex] + lhs[j]
                    (pointer + index).initialize(to: value)
                }
            }
        } else {
            // column vector
            // outer indices correspond to col
            // inner indices correspond to row
            for j in 0..<size.cols {
                for i in 0..<size.rows {
                    let index = elementIndex(i: i, j: j, size: size)
                    let rhsIndex = rhs.indices[j][i]
                    let value = rhs.valuePtr.pointer[rhsIndex] + lhs[i]
                    (pointer + index).initialize(to: value)
                }
            }
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    // MARK: - Subtraction
    public static func -<M: Matrix, T: Vector>(lhs: VectorwiseOp, rhs: T) -> M where T.Element == M.Element, T.Element: SignedNumeric, T.Element == V.Element {
        typealias S = T.Element
        assert(lhs.indices[0].count == rhs.count)
        
        let size: MatrixSize = [rhs.rows == 1 ? lhs.indices.count : rhs.rows,
                                rhs.cols == 1 ? lhs.indices.count : rhs.cols]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
        
        if rhs.rows == 1 {
            // row vector
            // outer index in indices correspond to row
            // inner index in indices correspoind to col
            for j in 0..<size.cols {
                for i in 0..<size.rows {
                    let index = elementIndex(i: i, j: j, size: size)
                    let lhsIndex = lhs.indices[i][j]
                    let value = lhs.valuePtr.pointer[lhsIndex] - rhs[j]
                    (pointer + index).initialize(to: value)
                }
            }
        } else {
            // column vector
            // outer indices correspond to col
            // inner indices correspond to row
            for j in 0..<size.cols {
                for i in 0..<size.rows {
                    let index = elementIndex(i: i, j: j, size: size)
                    let lhsIndex = lhs.indices[j][i]
                    let value = lhs.valuePtr.pointer[lhsIndex] - rhs[i]
                    (pointer + index).initialize(to: value)
                }
            }
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public static func -<M: Matrix, T: Vector>(lhs: T, rhs: VectorwiseOp) -> M where T.Element == M.Element, T.Element: SignedNumeric, T.Element == V.Element {
        typealias S = T.Element
        assert(rhs.indices[0].count == lhs.count)
        
        let size: MatrixSize = [lhs.rows == 1 ? rhs.indices.count : lhs.rows,
                                lhs.cols == 1 ? rhs.indices.count : lhs.cols]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
        
        if lhs.rows == 1 {
            // row vector
            // outer index in indices correspond to row
            // inner index in indices correspoind to col
            for j in 0..<size.cols {
                for i in 0..<size.rows {
                    let index = elementIndex(i: i, j: j, size: size)
                    let rhsIndex = rhs.indices[i][j]
                    let value = rhs.valuePtr.pointer[rhsIndex] + lhs[j]
                    (pointer + index).initialize(to: value)
                }
            }
        } else {
            // column vector
            // outer indices correspond to col
            // inner indices correspond to row
            for j in 0..<size.cols {
                for i in 0..<size.rows {
                    let index = elementIndex(i: i, j: j, size: size)
                    let rhsIndex = rhs.indices[j][i]
                    let value = rhs.valuePtr.pointer[rhsIndex] + lhs[i]
                    (pointer + index).initialize(to: value)
                }
            }
        }
        
        return .init(SharedPointer(pointer), size)
    }
}
