//
//  Vec3.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Vec3<T: MatrixElement>: Vector {
    public typealias TransposeType = RVec3<T>
    public typealias RowType = T
    public typealias ColType = Vec3<T>
    public static var Rows: Int { 3 }
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
    
    public var z: T {
        self[2]
    }
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size == [3, 1])
        
        self.size = size
        self.valuesPtr = pointer
        capacity = size.count
    }
    
    public init(_ x: T, _ y: T, _ z: T) {
        self.init([x, y, z], [3, 1])
    }
}
