//
//  MatX4.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct MatX4<T: MatrixElement>: Matrix {
    public typealias TransposeType = Mat4X<T>
    public typealias RowType = RVec4<T>
    public typealias ColType = Vec<T>
    public static var Rows: Int { 0 }
    public static var Cols: Int { 4 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.cols == 4)
        
        self.size = size
        self.valuesPtr = pointer
    }
}
