//
//  is_symmetric.swift
//  Fashionator
//
//  Created by Reza on 4/27/23.
//

import Foundation

// Returns true if the given matrix is symmetric
// Inputs:
//   A  m by m matrix
// Returns true if the matrix is square and symmetric
public func is_symmetric<S: MatrixElement & SignedNumeric>(_ A: SparseMatrix<S>) -> Bool {
    if (A.rows != A.cols) { return false }
    assert(A.size.count != 0)
    
    let AT = A.transpose()
    let AmAT = A - AT
    
    return AmAT.nonZeros == 0
}

// Inputs:
// epsilon threshold on L1 difference between A and A'
public func is_symmetric<S: MatrixElement & SignedNumeric & Comparable>(_ A: SparseMatrix<S>, _ epsilon: S) -> Bool {
    if (A.rows != A.cols) { return false }
    assert(A.size.count != 0)
    
    let AT = A.transpose()
    let AmAT = A - AT
    var AmATI = Vec<Int>()
    var AmATJ = Vec<Int>()
    var AmATV = Vec<S>()
    find(AmAT, &AmATI, &AmATJ, &AmATV)
    
    if (AmATI.count == 0) { return true }
    
    return (AmATV.maxCoeff() < epsilon && AmATV.minCoeff() > -epsilon)
}
