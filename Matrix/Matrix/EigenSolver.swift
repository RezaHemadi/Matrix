//
//  EigenSolver.swift
//  Matrix
//
//  Created by Reza on 8/31/23.
//

import Foundation
import Accelerate

enum EigenValueError: Swift.Error {
    case internalError
    case parameterHasIllegalValue(parameterIndex: Int)
    case failedToConverge(firstConvergedIndex: Int)
}

public struct EigenSolver<M: Matrix> where M.Element == Double {
    // MARK: - Properties
    private let n: Int
    public var realEigenValues: Vec<Double>
    public var imaginaryEigenValues: Vec<Double>
    public var eigenVectors: Mat<Double>
    
    // MARK: - Initialization
    public init(squareMatrix m: M) throws {
        assert(m.rows == m.cols, "Matrix must be square")
        
        var a = m.values
        n = m.rows
        var valsR: [Double] = .init(repeating: 0.0, count: n)
        var valsIm: [Double] = .init(repeating: 0.0, count: n)
        var eigenVecs: [Double] = .init(repeating: 0.0, count: n * n)
        
        try ComputeEigenValuesAndVectors(matrix: &a,
                                         dimension: n,
                                         eigenValsReal: &valsR,
                                         eigenValsImaginary: &valsIm,
                                         eigenVectors: &eigenVecs)
        realEigenValues = .init(valsR, [n, 1])
        imaginaryEigenValues = .init(valsIm, [n, 1])
        eigenVectors = .init(n, n)
        var eigenMap: [Double:Vec<Double>] = [:]
        eigenMap.reserveCapacity(n)
        
        for i in 0..<n {
            let startIdx: Int = i * n
            let endIdx: Int = (i + 1) * n - 1
            let vec: Vec<Double> = .init(Array(eigenVecs[startIdx...endIdx]))
            eigenMap[realEigenValues[i]] = vec
        }
        
        let sortedEigenMap = eigenMap.sorted(by: {$0.key < $1.key})
        
        var i = 0
        for (key, value) in sortedEigenMap {
            realEigenValues[i] = key
            eigenVectors.col(i) <<== value
            i += 1
        }
    }
    
    // MARK: - Helper Methods
    
}

private func dgeev(matrixA: UnsafeMutablePointer<Double>,
           count: Int,
           eienValsReal wr: UnsafeMutablePointer<Double>,
           eigenValsImaginary wi: UnsafeMutablePointer<Double>,
           eigenVecs vl: UnsafeMutablePointer<Double>,
           workspace work: UnsafeMutablePointer<Double>,
           workspacecount lwork: Int) -> Int {
    // We want to compute the left eigenvectors
    let jobvl = Int8("V".utf8.first!)
    
    // No need to compute right hand eigenvectors
    let jobvr = Int8("N".utf8.first!)
    
    // The order of the matrix A
    let n = __LAPACK_int(count)
    
    // Leading dimension of A
    let lda = __LAPACK_int(count)
    
    // Leading dimension of the array VL
    let ldvl = __LAPACK_int(count)
    
    let lwork = __LAPACK_int(lwork)
    
    var info: Int = 0
    
    withUnsafePointer(to: jobvl) { jobvl in
        withUnsafePointer(to: jobvr) { jobvr in
            withUnsafePointer(to: n) { n in
                withUnsafePointer(to: lda) { lda in
                    withUnsafePointer(to: ldvl) { ldvl in
                        withUnsafePointer(to: lwork) { lwork in
                            dgeev_(jobvl,
                                   jobvr,
                                   n,
                                   matrixA,
                                   lda,
                                   wr,
                                   wi,
                                   vl,
                                   ldvl,
                                   nil,
                                   ldvl,
                                   work,
                                   lwork,
                                   &info)
                        }
                    }
                }
            }
        }
    }
    
    return info
}

private func ComputeEigenValuesAndVectors(matrix: inout [Double],
                                  dimension: Int,
                                  eigenValsReal: inout [Double],
                                  eigenValsImaginary: inout [Double],
                                  eigenVectors: inout [Double]) throws {
    // Pass '-1' to the 'lwork' parameter of '_dgeev' to calculate the optimal size for the
    // workspace array. The function writes the optimal size to the 'workSpace' variable.
    var workspaceCount = Double(0)
    
    // query and allocate the optimal workspace
    let err = dgeev(matrixA: &matrix,
                    count: dimension,
                    eienValsReal: &eigenValsReal,
                    eigenValsImaginary: &eigenValsImaginary,
                    eigenVecs: &eigenVectors,
                    workspace: &workspaceCount,
                    workspacecount: -1)
    if (err != 0) {
        throw EigenValueError.internalError
    }
    
    let workspace: UnsafeMutablePointer<Double> = .allocate(capacity: Int(workspaceCount))
    defer {
        workspace.deallocate()
    }
    
    // Perform the calculation by passing the workspace array size to the 'lwork' parameter of 'dgeev_'
    let info = dgeev(matrixA: &matrix,
                     count: dimension,
                     eienValsReal: &eigenValsReal,
                     eigenValsImaginary: &eigenValsImaginary,
                     eigenVecs: &eigenVectors,
                     workspace: workspace,
                     workspacecount: Int(workspaceCount))
    
    if (info < 0) {
        throw EigenValueError.parameterHasIllegalValue(parameterIndex: abs(info))
    } else if (info > 0) {
        throw EigenValueError.failedToConverge(firstConvergedIndex: info + 1)
    }
}
