//
//  SimplicalLDLT.swift
//  Matrix
//
//  Created by Reza on 7/17/23.
//

import Foundation

/// Solver for sparse matrix type
public class SimplicalLDLT<S: MatrixElement & Numeric> {
    // MARK: - Properties
    public var info: SolverInfo
    
    // MARK: - Initialization
    public init() {
        fatalError("To be implemented")
    }
    
    // MARK: - Methods
    public func factorize(_ mtr: SparseMatrix<S>) {
        fatalError("To be implemented")
    }
    
    public func solve<V: Vector>(_ rhs: V) -> Vec<S> where V.Element == S {
        fatalError("To be implemented")
    }
}
