//
//  MBoolReduce.swift
//  ClothSimulation
//
//  Created by Reza on 1/26/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct MBoolReduce<T: MatrixElement> {
    // MARK: - Properties
    private let valuesPtr: SharedPointer<T>
    private let _count: Int
    private let predicate: (T) -> Bool
    
    // MARK: - Initialization
    public init(pointer: SharedPointer<T>, count: Int, predicate: @escaping (T) -> Bool) {
        self.valuesPtr = pointer
        self._count = count
        self.predicate = predicate
    }
    
    // MARK: - Methods
    public func any() -> Bool {
        for i in 0..<_count {
            if predicate(valuesPtr.pointer[i]) { return true }
        }
        return false
    }
    
    public func all() -> Bool {
        for i in 0..<_count {
            if !predicate(valuesPtr.pointer[i]) { return false }
        }
        return true
    }
    
    public func count() -> Int {
        var total: Int = 0
        for i in 0..<_count {
            if predicate(valuesPtr.pointer[i]) { total += 1 }
        }
        return total
    }
}
