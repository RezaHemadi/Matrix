//
//  RVec4.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct RVec4<T: MatrixElement>: Vector {
    public typealias TransposeType = Vec4<T>
    public typealias RowType = RVec4<T>
    public typealias ColType = T
    public static var Rows: Int { 1 }
    public static var Cols: Int { 4 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    public var capacity: Int
    public var xyz: RVec3<T> {
        let ptr: UnsafeMutablePointer<T> = .allocate(capacity: 3)
        ptr.initialize(from: self.valuesPtr.pointer, count: 3)
        return .init(SharedPointer(ptr), [1, 3])
    }
    
    // MARK: - Initialization
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size == [1, 4])
        self.size = size
        self.valuesPtr = pointer
        capacity = size.count
    }
    
    public init(xyz: RVec3<T>, w: T) {
        let ptr: UnsafeMutablePointer<T> = .allocate(capacity: 4)
        ptr.initialize(from: xyz.valuesPtr.pointer, count: 3)
        (ptr + 3).initialize(to: w)
        
        self.init(SharedPointer(ptr), [1, 4])
    }
}
