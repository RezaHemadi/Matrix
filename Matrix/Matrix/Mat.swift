//
//  Mat.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Mat<T: MatrixElement>: Matrix {
    public typealias TransposeType = Mat<T>
    public typealias RowType = RVec<T>
    public typealias ColType = Vec<T>
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        valuesPtr = pointer
        self.size = size
    }
}

extension Mat {
    // MARK: - Statics
    public static var Rows: Int { 0 }
    public static var Cols: Int { 0 }
}
