//
//  Mat32.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Mat32<T: MatrixElement>: Matrix {
    public typealias TransposeType = Mat<T>
    public typealias RowType = RVec2<T>
    public typealias ColType = Vec3<T>
    public static var Rows: Int { 3 }
    public static var Cols: Int { 2 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size == [3, 2])
        self.size = size
        self.valuesPtr = pointer
    }
}
