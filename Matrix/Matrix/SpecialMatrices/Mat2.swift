//
//  Mat2.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Mat2<T: MatrixElement>: Matrix {
    public typealias TransposeType = Mat2<T>
    public typealias RowType = RVec2<T>
    public typealias ColType = Vec2<T>
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.rows == 2 && size.cols == 2)
        
        self.valuesPtr = pointer
        self.size = size
    }
}

extension Mat2 {
    // MARK: - Statics
    public static var Rows: Int { 2 }
    public static var Cols: Int { 2 }
}

extension Mat2: SquareMatrix {}
