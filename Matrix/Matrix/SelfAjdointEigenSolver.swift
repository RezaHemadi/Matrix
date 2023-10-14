//
//  SelfAjdointEigenSolver.swift
//  Matrix
//
//  Created by Reza on 10/4/23.
//

import Foundation
import Accelerate

public struct SelfAdjointEigenSolver<M: Matrix> where M.Element == Double {
    // MARK: - Properties
    private let n: Int
    public var eigenValues: Vec<Double>
    public var eigenVectors: Mat<Double>!
    
    // MARK: - Initialization
    public init(squareMatrix m: M, computeEigenVectors: Bool = true) throws {
        assert(m.rows == m.cols, "Matrix must be square")
        
        var a: [Double] = m.values
        n = m.rows
        
        var eigenVals: [Double]
        var eigenVecs: [Double]
        
        (eigenVecs, eigenVals) = try ComputeEigenValues(matrix: &a,
                                                        dimension: n,
                                                        computeEigenVectors: computeEigenVectors)
        eigenValues = .init(eigenVals)
        eigenVectors = Mat<Double>.init(eigenVecs, [n, n]).transpose()
    }
}

private func dsyev(matrixA: UnsafeMutablePointer<Double>,
                   count: Int,
                   computeEigenVectors: Bool,
                   eigenValues w: UnsafeMutablePointer<Double>,
                   workspace work: UnsafeMutablePointer<Double>,
                   workspacecount lwork: Int) -> Int {
    // whether to compute eigenvectors
    let jobz = Int8(computeEigenVectors ? "V".utf8.first! : "N".utf8.first!)
    // store upper triangle entries
    let uplo = Int8("U".utf8.first!)
    // the order of the matrix A
    let n = __LAPACK_int(count)
    // the leading dimension of A
    let lda = __LAPACK_int(count)
    let lwork = __LAPACK_int(lwork)
    var info: Int = 0
    
    withUnsafePointer(to: jobz) { jobz in
        withUnsafePointer(to: uplo) { uplo in
            withUnsafePointer(to: n) { n in
                withUnsafePointer(to: lda) { lda in
                    withUnsafePointer(to: lwork) { lwork in
                        dsyev_(jobz, uplo, n, matrixA, lda, w, work, lwork, &info)
                    }
                }
            }
        }
    }
    
    return info
}

private func ComputeEigenValues(matrix: inout [Double],
                                dimension: Int,
                                computeEigenVectors: Bool) throws -> ([Double], [Double]) {
    // pass '-1' to the 'lwork' parameter of 'dsyev' to calculate the optimal size for the
    // workspace array. the function writes the optimal size to the 'workspace' variable
    var workSpaceCount = Double(0)
    
    var eigenVals: [Double] = .init(repeating: .zero, count: dimension)
    
    // query and allocate the optimal workspace
    let err = dsyev(matrixA: &matrix,
                    count: dimension,
                    computeEigenVectors: computeEigenVectors,
                    eigenValues: &eigenVals,
                    workspace: &workSpaceCount,
                    workspacecount: -1)
    if (err != 0) {
        throw EigenValueError.internalError
    }
    
    let workspace: UnsafeMutablePointer<Double> = .allocate(capacity: Int(workSpaceCount))
    defer {
        workspace.deallocate()
    }
    
    // Perform the calculation by passing the workspace array size to the 'lwork' parameter
    let info = dsyev(matrixA: &matrix,
                     count: dimension,
                     computeEigenVectors: computeEigenVectors,
                     eigenValues: &eigenVals,
                     workspace: workspace,
                     workspacecount: Int(workSpaceCount))
    if (info == 0) {
        return (matrix, eigenVals)
    } else if info < 0 {
        throw EigenValueError.parameterHasIllegalValue(parameterIndex: -info)
    } else {
        throw EigenValueError.failedToConverge(firstConvergedIndex: info)
    }
}
