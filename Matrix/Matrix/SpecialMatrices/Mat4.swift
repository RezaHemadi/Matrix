//
//  Mat4.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Mat4<T: MatrixElement>: Matrix {
    public typealias TransposeType = Mat4<T>
    public typealias RowType = RVec4<T>
    public typealias ColType = Vec4<T>
    public static var Rows: Int { 4 }
    public static var Cols: Int { 4 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.rows == 4 && size.cols == 4)
        
        self.valuesPtr = pointer
        self.size = size
    }
}

extension Mat4: SquareMatrix {}
