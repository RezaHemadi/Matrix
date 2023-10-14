//
//  SimplicalLDLT.swift
//  Matrix
//
//  Created by Reza on 7/17/23.
//

import Foundation
import Accelerate

/// Solver for sparse matrix type
public class SimplicalLDLT{
    // MARK: - Properties
    public var info: SolverInfo = .success
    public var factorization: SparseOpaqueFactorization_Double?
    
    // MARK: - Initialization
    public init() { }
    
    deinit {
        if factorization != nil {
            SparseCleanup(factorization!)
        }
    }
    
    // MARK: - Methods
    public func factorize(_ mtr: SparseMatrix<Double>) {
        var rowIndices: [Int32] = mtr.innerIndices.map({ Int32($0) })
        var columnStarts: [Int] = mtr.outerStarts
        
        let structure: SparseMatrixStructure = rowIndices.withUnsafeMutableBufferPointer { rowIndicesPtr in
            columnStarts.withUnsafeMutableBufferPointer { columnStartsPtr in
                var attributes = SparseAttributes_t()
                attributes.triangle = SparseLowerTriangle
                attributes.kind = SparseSymmetric
                
                return SparseMatrixStructure(rowCount: Int32(mtr.rows),
                                             columnCount: Int32(mtr.cols),
                                             columnStarts: columnStartsPtr.baseAddress!,
                                             rowIndices: rowIndicesPtr.baseAddress!,
                                             attributes: attributes,
                                             blockSize: 1)
            }
        }
        
        var values = mtr.values!
        
        let llt: SparseOpaqueFactorization_Double = values.withUnsafeMutableBufferPointer { valuesPtr in
            let a = SparseMatrix_Double(structure: structure,
                                        data: valuesPtr.baseAddress!)
            return SparseFactor(SparseFactorizationLDLT, a)
        }
        
        factorization = llt
    }
    
    public func solve<V: Vector>(_ rhs: V) -> Vec<Double> where V.Element == Double {
        assert(factorization != nil, "factorization must be called before solve!")
        
        var bValues: [Double] = rhs.values
        var xValues: [Double] = .init(repeating: 0.0, count: rhs.count)
        let count = Int32(bValues.count)
        
        bValues.withUnsafeMutableBufferPointer { bPtr in
            xValues.withUnsafeMutableBufferPointer { xPtr in
                let b = DenseVector_Double(count: count,
                                           data: bPtr.baseAddress!)
                
                let x = DenseVector_Double(count: count,
                                           data: xPtr.baseAddress!)
                
                SparseSolve(factorization!, b, x)
            }
        }
        
        SparseCleanup(factorization!)
        factorization = nil
        
        return .init(xValues)
    }
}
