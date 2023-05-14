//
//  SparseLLT.swift
//  Fashionator
//
//  Created by Reza on 5/4/23.
//

import Foundation
import Accelerate

// Implement LLT (Cholesky) factorization of a sparse matrix
public class SparseLLT {
    // MARK: - Properties
    public let A: SparseMatrix_Double
    public let factorization: SparseOpaqueFactorization_Double
    
    // MARK: - Initialization
    public init(_ m: SparseMatrix<Double>, transpose: Bool) {
        var rowIndices: [Int32] = []
        var columnIndices: [Int32] = []
        var aValues: [Double] = []
        
        // iterate over sparse matrix to populate triplets
        for outerIndex in 0..<m.outerSize {
            for it in m.innerIterator(outerIndex) {
                // only use values on lower triangle since matrix is symmetric
                guard (it.row >= it.col) else { continue }
                
                rowIndices.append(Int32(it.row))
                columnIndices.append(Int32(it.col))
                aValues.append(it.value)
            }
        }
        
        var attributes = SparseAttributes_t()
        attributes.kind = SparseSymmetric
        attributes.triangle = SparseLowerTriangle
        attributes.transpose = transpose
        A = SparseConvertFromCoordinate(Int32(m.rows),
                                        Int32(m.cols),
                                        aValues.count,
                                        1,
                                        attributes,
                                        rowIndices,
                                        columnIndices,
                                        aValues)
        let symbolicOptions = SparseSymbolicFactorOptions(control: SparseDefaultControl,
                                                          orderMethod: SparseOrderDefault,
                                                          order: nil,
                                                          ignoreRowsAndColumns: nil,
                                                          malloc: { malloc($0) },
                                                          free: { free($0) },
                                                          reportError: nil)
        let numericOptions = SparseNumericFactorOptions()
        factorization = SparseFactor(SparseFactorizationLDLT, A, symbolicOptions, numericOptions)
    }
    
    // MARK: - Deinit
    deinit {
        SparseCleanup(A)
        SparseCleanup(factorization)
    }
    
    // MARK: - Methods
    public func solve(b: Vec<Double>) -> Vec<Double> {
        assert(b.count == Int(A.structure.columnCount))
        
        // Initialize output
        let output: Vec<Double> = .init(b.count)
        
        let b_vec = DenseVector_Double(count: Int32(b.count), data: b.valuesPtr.pointer)
        let x_vec = DenseVector_Double(count: Int32(output.count), data: output.valuesPtr.pointer)
        SparseSolve(factorization, b_vec, x_vec)
        
        return output
    }
    
    public func solve<M: Matrix>(b: M) -> Vec<Double> where M.Element == Double {
        assert(b.rows == Int(A.structure.columnCount))
        
        // Initialize output
        let output: Vec<Double> = .init(b.rows)
        
        let b_vec = DenseVector_Double(count: Int32(b.rows), data: b.valuesPtr.pointer)
        let x_vec = DenseVector_Double(count: Int32(output.count), data: output.valuesPtr.pointer)
        SparseSolve(factorization, b_vec, x_vec)
        
        return output
    }
}
