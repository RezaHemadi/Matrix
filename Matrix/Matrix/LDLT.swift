//
//  LDLT.swift
//  Matrix
//
//  Created by Reza on 7/9/23.
//

import Foundation

// Perform LDLT decomposition and solving of dense matrix
public class LDLT<T: MatrixElement & Numeric> {
    // MARK: - Properties
    public var info: SolverInfo
    
    // MARK: - Initialization
    public init() {
        fatalError("To be implemented")
    }
    
    public init<M: Matrix>(_ m: M) where M.Element == T {
        fatalError("To be implemented")
    }
    
    // MARK: - Methods
    public func solve(_ b: Vec<T>) -> Vec<T> {
        fatalError("To be implemented")
    }
    
    public func analyzePattern(_ mtr: SparseMatrix<T>) {
        fatalError("To be implemented")
    }
    
    public func compute<M: Matrix>(_ m: M) where M.Element == T {
        fatalError("To be implemented")
    }
}
