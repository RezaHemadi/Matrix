//
//  SparseQR.swift
//  Fashionator
//
//  Created by Reza on 4/27/23.
//

import Foundation
import Accelerate

/// Implements a QR decomposition of sparse matrix
public class SparseQR {
    // MARK: - Properties
    private let ordering: OrderingType
    private var A: SparseMatrix_Double
    private var factorization: SparseOpaqueFactorization_Double
    
    // MARK: - Initialization
    public init(_ m: SparseMatrix<Double>, transpose: Bool,  ordering: OrderingType) {
        self.ordering = ordering
        
        var rowIndices: [Int32] = []
        var columnIndices: [Int32] = []
        var aValues: [Double] = []
        
        // iterate over sparse matrix to populate triplets
        for outerIndex in 0..<m.outerSize {
            for it in m.innerIterator(outerIndex) {
                rowIndices.append(Int32(it.row))
                columnIndices.append(Int32(it.col))
                aValues.append(it.value)
            }
        }
        var attributes = SparseAttributes_t()
        attributes.transpose = transpose
        A = SparseConvertFromCoordinate(Int32(m.rows),
                                        Int32(m.cols),
                                        m.nonZeros,
                                        1,
                                        attributes,
                                        rowIndices,
                                        columnIndices,
                                        aValues)
        let symbolicOptions: SparseSymbolicFactorOptions
        
        switch ordering {
        case .AMDOrdering:
            symbolicOptions = .init(control: SparseDefaultControl,
                                    orderMethod: SparseOrderAMD,
                                    order: nil,
                                    ignoreRowsAndColumns: nil,
                                    malloc: { malloc($0) },
                                    free: { free($0) },
                                    reportError: nil)
        case .COLAMDOrdering:
            symbolicOptions = .init(control: SparseDefaultControl,
                                    orderMethod: SparseOrderCOLAMD,
                                    order: nil,
                                    ignoreRowsAndColumns: nil,
                                    malloc: { malloc($0) },
                                    free: { free($0) },
                                    reportError: nil)
        case .NaturalOrdering:
            symbolicOptions = .init(control: SparseDefaultControl,
                                    orderMethod: SparseOrderDefault,
                                    order: nil,
                                    ignoreRowsAndColumns: nil,
                                    malloc: { malloc($0) },
                                    free: { free($0) },
                                    reportError: nil)
        }
        let numericOptions = SparseNumericFactorOptions()
        factorization = SparseFactor(SparseFactorizationQR,
                                     A,
                                     symbolicOptions,
                                     numericOptions)
    }
    
    // MARK: - Methods
}
