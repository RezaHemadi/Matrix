//
//  Mat3.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Mat3<T: MatrixElement>: Matrix {
    public typealias TransposeType = Mat3<T>
    public typealias RowType = RVec3<T>
    public typealias ColType = Vec3<T>
    public static var Rows: Int { 3 }
    public static var Cols: Int { 3 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.rows == 3 && size.cols == 3)
        
        self.valuesPtr = pointer
        self.size = size
    }
}

extension Mat3: SquareMatrix {}
