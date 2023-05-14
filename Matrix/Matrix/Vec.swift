//
//  Vec.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Vec<T: MatrixElement>: Vector {
    public typealias TransposeType = RVec<T>
    public typealias RowType = T
    public typealias ColType = Vec<T>
    public static var Cols: Int { 1 }
    public static var Rows: Int { 0 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.cols == 1)
        
        valuesPtr = pointer
        self.size = size
    }
}
