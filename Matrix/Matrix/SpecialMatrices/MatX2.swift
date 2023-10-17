//
//  MatX2.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct MatX2<T: MatrixElement>: Matrix {
    public typealias TransposeType = Mat2X<T>
    public typealias RowType = RVec2<T>
    public typealias ColType = Vec<T>
    public static var Rows: Int { 0 }
    public static var Cols: Int { 2 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    public var capacity: Int
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.cols == 2)
        
        self.valuesPtr = pointer
        self.size = size
        capacity = size.count
    }
}
