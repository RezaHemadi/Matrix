//
//  RVec.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct RVec<T: MatrixElement>: Vector {
    public typealias TransposeType = Vec<T>
    public typealias RowType = RVec<T>
    public typealias ColType = T
    public static var Rows: Int { 1 }
    public static var Cols: Int { 0 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.rows == 1)
        
        valuesPtr = pointer
        self.size = size
    }
}
