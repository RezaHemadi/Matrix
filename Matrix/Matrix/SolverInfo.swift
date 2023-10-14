//
//  SolverInfo.swift
//  Matrix
//
//  Created by Reza on 7/17/23.
//

import Foundation

public enum SolverInfo {
    /// computation was successful
    case success
    /// the provided data did not satisfy the prerequisites
    case numericalIssue
    /// iterative procedure did not converge
    case NoConvergence
    /// The inputs are invalid, or the algorithm has been temporarily called
    case invalidInput
}
