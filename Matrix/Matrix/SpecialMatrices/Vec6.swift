//
//  Vec6.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Vec6<T: MatrixElement>: Vector {
    public typealias TransposeType = RVec<T>
    public typealias RowType = T
    public typealias ColType = Vec6<T>
    public static var Rows: Int { 6 }
    public static var Cols: Int { 1 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    public var capacity: Int
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size == [6, 1])
        self.size = size
        self.valuesPtr = pointer
        capacity = size.count
    }
}
