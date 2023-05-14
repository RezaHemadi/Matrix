//
//  SelfAdjointEigenSolver.swift
//  ClothSimulation
//
//  Created by Reza on 2/8/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

class SelfAdjointEigenSolver {
    // MARK: - Properties
    var m_eivec: Mat<Double>
    var m_eivalues: Vec<Double>
    var m_subdiag: Vec<Double>
    var m_hcoeffs: Vec<Double>
    var m_info: String?
    var m_isInitialized: Bool
    var m_eigenvectorsOk: Bool
    
    // MARK: - Initialization
    init<M: Matrix>(matrix: M, options: Int) where M.Element == Double {
        m_eivec = .init(matrix.rows, matrix.cols)
        m_eivalues = .init(matrix.cols)
        m_subdiag = .init(matrix.rows > 1 ? matrix.rows - 1 : 1)
        m_hcoeffs = .init(matrix.cols > 1 ? matrix.cols - 1 : 1)
        m_isInitialized = false
        m_eigenvectorsOk = false
        
        compute(matrix, options)
    }
    
    // MARK: - Methods
    func compute<M: Matrix>(_ matrix: M, _ options: Int) where M.Element == Double {
        let n = matrix.cols
        m_eivalues.resize(n)
        
        if (n == 1) {
            m_eivec = .init(matrix, matrix.rows, matrix.cols)
            m_eivalues[0, 0] = m_eivec[0, 0]
            m_info = "Success"
            m_isInitialized = true
            m_eigenvectorsOk = false
        }
    }
}
