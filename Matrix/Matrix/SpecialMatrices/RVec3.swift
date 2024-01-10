//
//  RVec3.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct RVec3<T: MatrixElement>: Vector {
    public typealias TransposeType = Vec3<T>
    public typealias RowType = RVec3<T>
    public typealias ColType = T
    public static var Rows: Int { 1 }
    public static var Cols: Int { 3 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    public var capacity: Int
    public var x: T {
        valuesPtr.pointer[0]
    }
    
    public var y: T {
        valuesPtr.pointer[1]
    }
    
    public var z: T {
        valuesPtr.pointer[2]
    }
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size == [1, 3])
        self.size = size
        self.valuesPtr = pointer
        capacity = size.count
    }
}

extension RVec3: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(valuesPtr.pointer[0])
        hasher.combine(valuesPtr.pointer[1])
        hasher.combine(valuesPtr.pointer[2])
    }
}
