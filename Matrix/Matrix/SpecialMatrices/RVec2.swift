//
//  RVec2.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct RVec2<T: MatrixElement>: Vector {
    public typealias TransposeType = Vec2<T>
    public typealias RowType = RVec2<T>
    public typealias ColType = T
    public static var Rows: Int { 1 }
    public static var Cols: Int { 2 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size == [1, 2])
        
        self.size = size
        self.valuesPtr = pointer
    }
    
    public init(_ x : T, _ y: T) {
        self.init([x, y], [1, 2])
    }
}
