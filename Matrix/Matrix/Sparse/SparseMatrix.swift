//
//  SparseMatrix.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation
import Accelerate


public struct SparseMatrix<T: MatrixElement & Numeric> {
    // MARK: - Properties
    public var size: MatrixSize!
    internal var values: [T]!
    internal var innerIndices: [Int]
    internal var outerStarts: [Int]
    
    public var rows: Int {
        return size?.rows ?? 0
    }
    
    public var cols: Int {
        return size?.cols ?? 0
    }
    
    /// number of non zero elements
    public var nonZeros: Int {
        return outerStarts.last ?? 0
    }
    
    // the number of columns (resp. rows) of the matrix if the storage order column major (resp. row major)
    // i.e. size along the outer dimension
    public var outerSize: Int {
        return cols
    }
    
    // size along the inner dimension
    public var innserSize: Int {
        return rows
    }
    
    // MARK: - Initialization
    public init() {
        innerIndices = []
        outerStarts = []
    }
    
    public init(size: MatrixSize, values: [T], innerIndices: [Int], outerStarts: [Int]) {
        self.size = size
        self.values = values
        self.innerIndices = innerIndices
        self.outerStarts = outerStarts
    }
    
    public init(_ rows: Int, _ cols: Int) {
        size = .init(rows, cols)
        innerIndices = []
        outerStarts = .init(repeating: -1, count: rows)
    }
    
    // copy initializer
    public init(_ m: SparseMatrix<T>) {
        size = m.size
        values = m.values
        innerIndices = m.innerIndices
        outerStarts = m.outerStarts
    }
    
    public init<I: Vector, J: Vector, V: Vector>(_ iVec: I, _ jVec: J, _ valuesVec: V, m: Int, n: Int) where I.Element == Int, J.Element == Int {
        fatalError("To be implemented")
    }
    
    public init<I: Vector, J: Vector, V: Vector>(_ iVec: I, _ jVec: J, _ valuesVec: V) where I.Element == Int, J.Element == Int {
        fatalError("To be implemented")
    }
    
    // MARK: Methods
    
    /// Removes all non zeros but keep allocated memory
    public mutating func setZero() {
        self.values.removeAll(keepingCapacity: true)
        self.innerIndices.removeAll(keepingCapacity: true)
        self.outerStarts = .init(repeating: -1, count: size.rows)
    }
    
    public mutating func resize(_ rows: Int, _ cols: Int) {
        size = [rows, cols]
        outerStarts = .init(repeating: -1, count: rows)
    }
    
    /// Preallocates reserveSize non zeros
    public mutating func reserve(_ reserveSize: Int) {
        values = []
        values.reserveCapacity(reserveSize)
    }
    
    public mutating func setFromTriplets(_ triplets: [Triplet<T>]) {
        if size == nil { fatalError("matrix size not set") }
        guard !outerStarts.isEmpty else { fatalError("outer starts array not populated.") }
                
        if size == nil { fatalError("matrix size not set") }
        guard !outerStarts.isEmpty else { fatalError("outer starts array not populated.") }
        
        // allocate values to number of triplets
        let n = triplets.count
        if values == nil {
            values = []
        }
        innerIndices.reserveCapacity(n)
        
        var curIdx: Int = 0
        var outers: [Int] = []
        var rowIndices: [[Int]] = .init(repeating: [], count: size.rows)
        
        let triplets = triplets.sorted(by: { $0.i < $1.i }).filter({ $0.value != .zero })
        for i in 0..<triplets.count {
            rowIndices[triplets[i].i].append(i)
            
            if i == 0 {
                outers.append(triplets[i].i)
            } else {
                if outers.last! == triplets[i].i {
                    continue
                } else {
                    outers.append(triplets[i].i)
                }
            }
        }
        
        for i in outers {
            // slice triplets with current i
            let indices = rowIndices[i]
            
            // create index map of colIdx and value [Int:T]
            var rowTable: [Int:T] = [:]
            for index in indices {
                let curTriplet = triplets[index]
                if let originalValue = rowTable[curTriplet.j] {
                    rowTable[curTriplet.j] = curTriplet.value + originalValue
                } else {
                    rowTable[curTriplet.j] = curTriplet.value
                }
            }
            
            outerStarts[i] = curIdx
            for (colIdx, value) in rowTable {
                values.append(value)
                curIdx += 1
                innerIndices.append(colIdx)
            }
            
            /*
            for index in indices {
                values.append(triplets[index].value)
                curIdx += 1
                innerIndices.append(triplets[index].j)
            }*/
        }
        outerStarts.append(curIdx)
    }
    
    public mutating func forceAllNNZ(to value: T) {
        for i in 0..<nonZeros {
            values[i] = value
        }
    }
    
    /// row is zero indexed
    public func nzCount(row: Int) -> Int {
        assert( row < rows )
        
        var upperIdx = row + 1
        let lowerIdx = row
        
        // early exit for empty row
        if (outerStarts[lowerIdx] == -1) { return 0 }
        
        while (outerStarts[upperIdx] == -1) { upperIdx += 1 }
        
        return (outerStarts[upperIdx] - outerStarts[lowerIdx])
    }
    
    /// Apply a custom closure to each element of matrix
    public mutating func unaryExpr(_ closure: (T) -> T) {
        for i in 0..<nonZeros {
            values[i] = closure(values[i])
        }
    }
    
    /// Prune entries lower than epsilon
    public mutating func prune(_ epsilon: T) {
        fatalError("To be implemented")
    }
    
    public mutating func prune(_ reference: T, _ epsilon: T) {
        fatalError("To be implemented")
    }
    
    public func transpose() -> SparseMatrix<T> {
        // extract triplets from current structure
        var triplets: [Triplet<T>] = []
        triplets.reserveCapacity(nonZeros)
        
        // iterate over nonzero entries
        for i in 0..<outerSize {
            for it in innerIterator(i) {
                triplets.append(.init(i: it.col, j: it.row, value: it.value))
            }
        }
        
        var output: SparseMatrix<T> = .init(size.cols, size.rows)
        output.setFromTriplets(triplets)
        
        return output
    }
    
    public func toDense() -> Mat<T> {
        fatalError("To be implemented")
    }
    
    public func innerIterator(_ outerIndex: Int) -> SMInnerIterator<T> {
        assert(outerIndex < outerSize)
        
        let innerNZCount = nzCount(row: outerIndex)
        let startIndex = outerStarts[outerIndex]
        
        if (startIndex != -1) {
            var inners: [Int] = []
            var values: [T] = []
            
            for t in startIndex..<(startIndex + innerNZCount) {
                inners.append(innerIndices[t])
                values.append(self.values[t])
            }
            
            return .init(innerNZCount,
                         outerIndex,
                         inners,
                         values)
        }
        return .init(0, outerIndex, [], [])
    }
    public func topLeftCorner(_ rows: Int , _ cols: Int) -> SparseMatrixBlock<T> {
        fatalError("To be implemented")
    }
    
    public func bottomRightCorner(_ rows: Int, _ cols: Int) -> SparseMatrixBlock<T> {
        fatalError("To be implemented")
    }
    
    public func block(_ rowStart: Int, _ colStart: Int, _ rows: Int, _ cols: Int) -> SparseMatrixBlock<T> {
        fatalError("To be implemented")
    }
    
    public mutating func setIdentity() {
        fatalError("To be implemented")
    }
    
    public func cwiseAbs() -> Self {
        fatalError("To be implemented")
    }
    
    /// Sum elements along the outer dimension
    public func outerSum<V: Vector>() -> V where V.Element == T, T: AdditiveArithmetic & ExpressibleByIntegerLiteral {
        // determine output dimension
        let dimension: Int = outerSize
        
        // Initialize output
        var output: V = .init(dimension)
        
        for i in 0..<dimension {
            let startIndex = outerStarts[i]
            if (startIndex == -1) { output[i] = 0; continue }
            let count = nzCount(row: i)
            var sum: T = 0
            for j in startIndex..<(startIndex + count) {
                sum += values[j]
            }
            output[i] = sum
        }
        
        return output
    }
}

extension SpMat: CustomStringConvertible {
    public var description: String {
        var output: String = ""
        output += "values:\n"
        for i in 0..<nonZeros {
            output += String(values[i])
            output += " "
        }
        output += "\n"
        output += "Inner Indices:\n"
        output += innerIndices.description
        output += "\n"
        output += "Outer starts:\n"
        output += outerStarts.description
        
        return output
    }
}

extension SparseMatrix {
    // MARK: - Static Initializers
    
    /// Create a diagonal sparse matrix from values in vector
    public static func Diagonal<V: Vector>(vector: V) -> Self where V.Element == T {
        var triplets: [Triplet<T>] = []
        for i in 0..<vector.count {
            triplets.append(.init(i: i, j: i, value: vector[i]))
        }
        
        var output: Self = .init(vector.count, vector.count)
        output.setFromTriplets(triplets)
        
        return output
    }
    
    /// Create an identity sparse matrix with 1.0 on the diagonal
    public static func Identity(dimension: Int) -> Self where T: ExpressibleByIntegerLiteral {
        var triplets: [Triplet<T>] = []
        for i in 0..<dimension {
            triplets.append(.init(i: i, j: i, value: 1))
        }
        
        var output: Self = .init(dimension, dimension)
        output.setFromTriplets(triplets)
        
        return output
    }
}
