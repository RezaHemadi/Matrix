//
//  LDLT.swift
//  Matrix
//
//  Created by Reza on 7/9/23.
//

import Foundation
import Accelerate

// Perform LDLT decomposition and solving of dense matrix
public class LDLT  {
    // MARK: - Properties
    
    // reports whether previous comutation was successful
    public var info: SolverInfo!
    public var values: UnsafeMutablePointer<Double>!
    private let n: Int
    
    // MARK: - Initialization
    public init() {
        n = 0
    }
    
    public init(_ _m: Mat<Double>) {
        assert(_m.rows == _m.cols)
        
        n = _m.rows
        values = _m.valuesPtr.pointer
    }
    
    // MARK: - Methods
    public func solve(_ b: Vec<Double>, _ result: inout Vec<Double>) {
        assert(b.count == n)
        if let solution = positive_definite_cholesky(a: values, b: b.valuesPtr.pointer, n: n, nrhs: 1) {
            result = .init(SharedPointer(solution), [n, 1])
            return
        }
        
        fatalError()
    }
    
    /// Compute / recompute the LDLT decomposition A = L D L^* = U^* D U of matrix
    public func compute(_ m: Mat<Double>) {
        fatalError("To be implemented")
    }
    
    private func positive_definite_cholesky(a a_p: UnsafeMutablePointer<Double>,
                                            b b_p: UnsafeMutablePointer<Double>,
                                            n p_n: Int,
                                            nrhs p_nrhs: Int) -> UnsafeMutablePointer<Double>? {
        let uplo: UnsafeMutablePointer<Int8> = .allocate(capacity: 1)
        uplo.initialize(to: Int8("L".utf8.first!))
        let n: UnsafeMutablePointer<__LAPACK_int> = .allocate(capacity: 1)
        n.initialize(to: __LAPACK_int(p_n))
        let nrhs: UnsafeMutablePointer<__LAPACK_int> = .allocate(capacity: 1)
        nrhs.initialize(to: __LAPACK_int(p_nrhs))
        let lda: UnsafeMutablePointer<__LAPACK_int> = .allocate(capacity: 1)
        lda.initialize(to: __LAPACK_int(p_n))
        let ldb: UnsafeMutablePointer<__LAPACK_int> = .allocate(capacity: 1)
        ldb.initialize(to: __LAPACK_int(p_n))
        let info: UnsafeMutablePointer<__LAPACK_int> = .allocate(capacity: 1)
        info.initialize(to: __LAPACK_int(0))
        //let a: UnsafeMutablePointer<Double> = .allocate(capacity: a_p.count)
        //a.initialize(from: a_p, count: a_p.count)
        //let b: UnsafeMutablePointer<Double> = .allocate(capacity: b_p.count)
        //b.initialize(from: b_p, count: b_p.count)
        let ipiv: UnsafeMutablePointer<__LAPACK_int> = .allocate(capacity: p_n)
        ipiv.initialize(repeating: __LAPACK_int(0), count: p_n)
        defer {
            uplo.deallocate()
            n.deallocate()
            nrhs.deallocate()
            lda.deallocate()
            ldb.deallocate()
            info.deallocate()
            //a.deallocate()
            //b.deallocate()
            ipiv.deallocate()
        }
        
        dposv_(uplo, n, nrhs, a_p, ldb, b_p, ldb, info)
        
        
        if (info.pointee < 0) {
            print("the \(-info.pointee) element had illegal value.")
            return nil
        } else if (info.pointee > 0) {
            print("the leading minor of order \(info.pointee) of A is not positive definite.")
            
            // fall back to symmetric solver
            info.pointee = 0
            var workSpaceCount = Double(0)
            let lwork: UnsafeMutablePointer<__LAPACK_int> = .allocate(capacity: 1)
            lwork.initialize(to: __LAPACK_int(-1))
            dsysv_(uplo, n, nrhs, a_p, lda, ipiv, b_p, ldb, &workSpaceCount, lwork, info)
            
            guard info.pointee == 0 else { fatalError() }
            
            let workspace: UnsafeMutablePointer<Double> = .allocate(capacity: Int(workSpaceCount))
            lwork.update(repeating: Int(workSpaceCount), count: 1)
            defer {
                lwork.deallocate()
                workspace.deallocate()
            }
            dsysv_(uplo, n, nrhs, a_p, lda, ipiv, b_p, ldb, workspace, lwork, info)
            
            if info.pointee < 0 {
                print("the \(-info.pointee) element had illegal value.")
                return nil
            } else if info.pointee > 0 {
                print("D(\(info.pointee),\(info.pointee)) is exactly zero.  The factorization has been completed, but the block diagonal matrix D is exactly singular, so the solution could not be computed")
                return nil
            }
            
        }
        
        let output: UnsafeMutablePointer<Double> = .allocate(capacity: p_n)
        output.initialize(from: b_p, count: p_n)
        
        return output
        
        /*
        let uplo = Int8("L".utf8.first!)
        let n = __LAPACK_int(n)
        let nrhs = __LAPACK_int(nrhs)
        let lda = __LAPACK_int(n)
        let ldb = __LAPACK_int(n)
        
        var info = __LAPACK_int(0)
        
        var mutableA = a
        var mutableB = b
        
        withUnsafePointer(to: uplo) { uplo in
            withUnsafePointer(to: n) { n in
                withUnsafePointer(to: nrhs) { nrhs in
                    withUnsafePointer(to: lda) { lda in
                        withUnsafePointer(to: ldb) { ldb in
                            dposv_(uplo,
                                   n,
                                   nrhs,
                                   &mutableA,
                                   lda,
                                   &mutableB,
                                   ldb,
                                   &info)
                        }
                    }
                }
            }
        }
        
        if (info < 0) {
            print("the \(-info) element had illegal value.")
            return nil
        } else if (info > 0) {
            print("the leading minor of order \(info) of A is not positive definite.")
            return nil
        }
        
        return mutableB*/
    }
}


/// Returns the _x_ in _Ax = b_ for a nonsquare coefficient matrix using `sgesv_`.
///
/// - Parameter a: The matrix _A_ in _Ax = b_ that contains `dimension * dimension`
/// elements.
/// - Parameter dimension: The order of matrix _A_.
/// - Parameter b: The matrix _b_ in _Ax = b_ that contains `dimension * rightHandSideCount`
/// elements.
/// - Parameter rightHandSideCount: The number of columns in _b_.
///
/// The function specifies the leading dimension (the increment between successive columns of a matrix)
/// of matrices as their number of rows.
private func nonsymmetric_general(a: [Double],
                                  dimension: Int,
                                  b: [Double],
                                  rightHandSideCount: Int) -> [Double]? {
    var info: __LAPACK_int = 0
    
    // create a mutable copy of the right hand side matrix _b_ that the function returns as the solution matrix _x_.
    var x = b
    
    /// Create a mutable copy of `a` to pass to the LAPACK routine. The routine overwrites `mutableA`
    /// with the factors `L` and `U` from the factorization `A = P * L * U`.
    var mutableA = a
    
    var ipiv = [__LAPACK_int](repeating: 0, count: dimension)
    
    /// Call `sgesv_` to compute the solution.
    withUnsafePointer(to: __LAPACK_int(dimension)) { n in
        withUnsafePointer(to: __LAPACK_int(rightHandSideCount)) { nrhs in
            dgesv_(n,
                   nrhs,
                   &mutableA,
                   n,
                   &ipiv,
                   &x,
                   n,
                   &info)
        }
    }
    
    if info != 0 {
        NSLog("nonsymmetric_general error \(info)")
        return nil
    }
    return x
}

/// Returns the _x_ in _Ax = b_ for a nonsquare coefficient matrix using `dsysv_`.
///
/// - Parameter a: The matrix _A_ in _Ax = b_ that contains `dimension * dimension`
/// elements. The function references the upper triangle of _A_.
/// - Parameter dimension: The order of matrix _A_.
/// - Parameter b: The matrix _b_ in _Ax = b_ that contains `dimension * rightHandSideCount`
/// elements.
/// - Parameter rightHandSideCount: The number of columns in _b_.
///
/// The function specifies the leading dimension (the increment between successive columns of a matrix)
/// of matrices as their number of rows.

/// - Tag: symmetric_indefinite_general
private func symmetric_indefinite_general(a: [Double],
                                          dimension: Int,
                                          b: [Double],
                                          rightHandSideCount: Int) -> [Double]? {
    /// Create a mutable copy of the right hand side matrix _b_ that the function returns as the solution matrix _x_.
    var x = b
    
    /// Create a mutable copy of `a` to pass to the LAPACK routine. The routine overwrites `mutableA`
    /// with the block diagonal matrix `D` and the multipliers that obtain the factor `U`.
    var mutableA = a
    
    var ipiv = [__LAPACK_int](repeating: 0, count: dimension)
    /// Pass `lwork = -1` to `ssysv_` to perform a workspace query that calculates the
    /// optimal size of the `work` array.
    var work = Double(0)
    dsysv(uplo: Int8("U".utf8.first!),
          n: __LAPACK_int(dimension),
          nrhs: __LAPACK_int(rightHandSideCount),
          a: &mutableA,
          lda: __LAPACK_int(dimension),
          ipiv: &ipiv,
          b: &x,
          ldb: __LAPACK_int(dimension),
          work: &work,
          lwork: -1)
    
    let workspace = UnsafeMutablePointer<Double>.allocate(capacity: Int(work))
    defer {
        workspace.deallocate()
    }
    
    /// Call `ssysv_` to compute the solution.
    let info = dsysv(uplo: Int8("U".utf8.first!),
                     n: __LAPACK_int(dimension),
                     nrhs: __LAPACK_int(rightHandSideCount),
                     a: &mutableA,
                     lda: __LAPACK_int(dimension),
                     ipiv: &ipiv,
                     b: &x,
                     ldb: __LAPACK_int(dimension),
                     work: workspace,
                     lwork: __LAPACK_int(work))
    
    if info != 0 {
        NSLog("symmetric_indefinite_general error \(info)")
        return nil
    }
    return x
}

// A wrapper around 'dssysv_' that accepts values rather than pointers to values.
@discardableResult
private func dsysv(uplo: CChar,
                   n: __LAPACK_int,
                   nrhs: __LAPACK_int,
                   a: UnsafeMutablePointer<Double>,
                   lda: __LAPACK_int,
                   ipiv: UnsafeMutablePointer<__LAPACK_int>,
                   b: UnsafeMutablePointer<Double>,
                   ldb: __LAPACK_int,
                   work: UnsafeMutablePointer<Double>,
                   lwork: __LAPACK_int) -> __LAPACK_int {
    
    var info: __LAPACK_int = 0
    
    withUnsafePointer(to: uplo) { uplo in
        withUnsafePointer(to: n) { n in
            withUnsafePointer(to: nrhs) { nrhs in
                withUnsafePointer(to: lda) { lda in
                    withUnsafePointer(to: ldb) { ldb in
                        withUnsafePointer(to: lwork) { lwork in
                            dsysv_(uplo,
                                   n,
                                   nrhs,
                                   a,
                                   lda,
                                   ipiv,
                                   b,
                                   ldb,
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
