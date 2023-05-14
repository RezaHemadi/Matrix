//
//  Mat2X.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Mat2X<T: MatrixElement>: Matrix {
    public typealias TransposeType = MatX2<T>
    public typealias RowType = RVec<T>
    public typealias ColType = Vec2<T>
    public static var Rows: Int { 2 }
    public static var Cols: Int { 0 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.rows == 2)
        
        self.valuesPtr = pointer
        self.size = size
    }
}
