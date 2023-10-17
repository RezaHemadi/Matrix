//
//  Vec4.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Vec4<T: MatrixElement>: Vector {
    public typealias TransposeType = RVec4<T>
    public typealias ColType = Vec4<T>
    public typealias RowType = T
    public static var Rows: Int { 4 }
    public static var Cols: Int { 1 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    public var capacity: Int
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size == [4, 1])
        self.size = size
        self.valuesPtr = pointer
        capacity = size.count
    }
}
