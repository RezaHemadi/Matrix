//
//  SparseMatrix+Operators.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension SparseMatrix {
    // MARK: - Addition
    public static func +(lhs: Self, rhs: Self) -> Self where T: AdditiveArithmetic {
        // Make Sure matrices have the same dimension
        assert(lhs.outerSize == rhs.outerSize && lhs.innserSize == rhs.innserSize)
        
        // Helper closure
        let processSpMatrix: (SparseMatrix<T>, Int, inout Int, inout [Int], inout [Int], inout [T]) -> Void = { mat, row, curIdx, innerIndices, outerStarts, values in
            outerStarts[row] = curIdx
            let nzCount = mat.nzCount(row: row)
            for t in mat.outerStarts[row]..<(mat.outerStarts[row] + nzCount) {
                let colIndex = mat.innerIndices[t]
                let val = mat.values[t]
                //(valuesPtr + curIdx).initialize(to: val)
                values.append(val)
                curIdx += 1
                innerIndices.append(colIndex)
            }
        }
        
        let rowSweep: (Int, Self, inout [(Int, T)]) -> Void = { row, mat, entries in
            let elementCount = mat.nzCount(row: row)
            let startIdx = mat.outerStarts[row]
            for t in startIdx..<(startIdx + elementCount) {
                if let index = entries.firstIndex(where: { $0.0 == mat.innerIndices[t] }) {
                    let initialVal: T = entries[index].1
                    let sum: T = initialVal + mat.values[t]
                    if (sum != .zero) {
                        entries[index] = (mat.innerIndices[t], sum)
                    } else {
                        entries.remove(at: index)
                    }
                } else {
                    entries.append((mat.innerIndices[t], mat.values[t]))
                }
            }
        }
        
        let processEntries: (inout [(Int, T)], inout [T], inout Int, inout [Int]) -> Void = { entries, values, curIdx, innerIndices in
            for entry in entries {
                //valuesPtr[curIdx] = entry.1
                values.append(entry.1)
                curIdx += 1
                innerIndices.append(entry.0)
            }
        }
        
        // Determine output size
        let size: MatrixSize = lhs.size
        var innerIndices: [Int] = []
        var outerStarts: [Int] = .init(repeating: -1, count: size.rows)
        var values: [T] = []
        
        var curIdx: Int = 0
        // Iterate over rows
        for i in 0..<size.rows {
            if lhs.outerStarts[i] == -1 {
                if rhs.outerStarts[i] == -1 { // early continue if outer index of lhs and rhs is all zeros
                    continue
                } else {
                    // rhs contains values on outer index i
                    processSpMatrix(rhs, i, &curIdx, &innerIndices, &outerStarts, &values)
                }
            } else if (rhs.outerStarts[i] == -1) {
                // lhs contains values on outer index i but rhs contains no values on outer index i
                processSpMatrix(lhs, i, &curIdx, &innerIndices, &outerStarts, &values)
            } else {
                // both lhs and rhs contain values on outer index i
                outerStarts[i] = curIdx
                
                // entry.0 is inner index and entry.1 is value
                var entries: [(Int, T)] = []
                rowSweep(i, lhs, &entries)
                rowSweep(i, rhs, &entries)
                
                // Process entries for row i
                // sort entries by ascending inner index
                entries.sort(by: { $0.0 < $1.0} )
                processEntries(&entries, &values, &curIdx, &innerIndices)
            }
        }
        outerStarts.append(curIdx)
        print("initializing sparse matrix with \(values.count) values")
        let output: Self = .init(size: size, values: values, innerIndices: innerIndices, outerStarts: outerStarts)
        return output
    }
    
    // MARK: - Subtraction
    public static func -(lhs: Self, rhs: Self) -> Self where T: SignedNumeric {
        return lhs + (-rhs)
    }
    
    public static prefix func -(_ m: Self) -> Self where T: SignedNumeric {
        let innerIndices = m.innerIndices
        let outerStarts = m.outerStarts
        
        return .init(size: m.size, values: m.values.map({ -$0 }), innerIndices: innerIndices, outerStarts: outerStarts)
    }
    
    // MARK: - Multiplication
    public static func *(lhs: T, rhs: Self) -> Self where T: Numeric {
        return .init(size: rhs.size, values: rhs.values.map({ $0 * lhs }), innerIndices: rhs.innerIndices, outerStarts: rhs.outerStarts)
    }
    
    public static func *(lhs: SparseMatrix, rhs: SparseMatrix) -> SparseMatrix {
        fatalError("To be implemented")
    }
    
    public static func *<M1: Matrix, M2: Matrix>(lhs: Self, rhs: M1) -> M2 where M1.Element == T, M2.Element == T {
        // make sure input matrix sizes are compatible
        assert(lhs.cols == rhs.rows)
        
        // determine output size
        let size: MatrixSize = [lhs.rows, rhs.cols]
        
        var output: M2 = .init(size.rows, size.cols)
        
        // iterate over lhs rows
        for i in 0..<lhs.rows {
            // determine number of non-zeros in current row
            let nnz = lhs.nzCount(row: i)
            
            // if there are no non-zeros row i of output is zero
            // otherwise perform multiplication
            if (nnz == 0) {
                // set ith row of output to zero
                // non necessary since output is initialized with zeros
                /*
                for j in 0..<size.cols {
                    output[i, j] = 0
                }*/
            } else {
                // prepare lhs row values
                let rowStartIdx = lhs.outerStarts[i]
                
                // perform multiplication
                // iterate over lhs columns ( whose count equals rhs rows )
                for j in 0..<rhs.cols {
                    // declare sum and initialize to zero
                    var sum: T = .zero
                    
                    for t in rowStartIdx..<(rowStartIdx + nnz) {
                        let columnIndex = lhs.innerIndices[t]
                        let value = lhs.values[t] * rhs[columnIndex, j]
                        sum += value
                    }
                    output[i, j] = sum
                }
            }
        }
        
        return output
    }
    
    public static func *<M: Matrix>(lhs: M, rhs: SparseMatrix) -> SparseMatrix where M.Element == T {
        fatalError("To be implemented")
    }
    
    public static func -=(lhs: inout SparseMatrix, rhs: SparseMatrix) where T: SignedNumeric {
        fatalError("To be implemented")
    }
}
