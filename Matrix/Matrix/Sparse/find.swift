//
//  find.swift
//  Fashionator
//
//  Created by Reza on 4/26/23.
//

import Foundation

// Find the non-zero entries and there respective indices in a sparse matrix.
// Like matlab's [I,J,V] = find(X)
//
// Templates:
//   T  should be a eigen sparse matrix primitive type like int or double
// Input:
//   X  m by n matrix whose entries are to be found
// Outputs:
//   I  nnz vector of row indices of non zeros entries in X
//   J  nnz vector of column indices of non zeros entries in X
//   V  nnz vector of type T non-zeros entries in X
public func find<S: MatrixElement>(_ X: SparseMatrix<S>,
                                   _ I: inout Veci,
                                   _ J: inout Veci,
                                   _ V: inout Vec<S>) {
    // Resize output to fit nonzeros
    let xNonZeros = X.nonZeros
    I.resize(xNonZeros)
    J.resize(xNonZeros)
    V.resize(xNonZeros)
    
    var i: Int = 0
    // iterate over outside
    for k in 0..<X.outerSize {
        // iterate over inside
        for it in X.innerIterator(k) {
            V[i] = it.value
            I[i] = it.row
            J[i] = it.col
            i += 1;
        }
    }
}
