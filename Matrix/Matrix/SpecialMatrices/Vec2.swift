//
//  Vec2.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Vec2<T: MatrixElement>: Vector {
    public typealias TransposeType = RVec2<T>
    public typealias RowType = T
    public typealias ColType = Vec2<T>
    public static var Rows: Int { 2 }
    public static var Cols: Int { 1 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    public var capacity: Int
    
    public var x: T {
        self[0]
    }
    
    public var y: T {
        self[1]
    }
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size == [2, 1])
        
        self.valuesPtr = pointer
        self.size = size
        capacity = size.count
    }
    
    public init(_ x: T, _ y: T) {
        self.init([x, y], [2, 1])
    }
}
