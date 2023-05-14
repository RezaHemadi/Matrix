//
//  Vector+cross.swift
//  ClothSimulation
//
//  Created by Reza on 1/16/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Vector where Element: Numeric {
    
    public func cross<V: Vector>(_ other: V) -> Vec3<Element> where V.Element == Element {
        let outputSize: MatrixSize = [3, 1]
        let outputPointer: UnsafeMutablePointer<Element> = .allocate(capacity: 3)
        let v0 = self[1] * other[2] - self[2] * other[1]
        outputPointer.initialize(to: v0)
        let v1 = self[2] * other[0] - self[0] * other[2]
        (outputPointer + 1).initialize(to: v1)
        let v2 = self[0] * other[1] - self[1] * other[0]
        (outputPointer + 2).initialize(to: v2)
        
        return .init(SharedPointer(outputPointer), outputSize)
    }
    
    public func cross<V: Vector, V1: Vector>(_ other: V) -> V1 where V.Element == Element, V1.Element == Element {
        assert(count == 3)
        
        let outputSize: MatrixSize = [V1.Rows == 1 ? 1 : count, V1.Cols == 1 ? 1 : count]
        let outputPointer: UnsafeMutablePointer<Element> = .allocate(capacity: outputSize.count)
        let v0 = self[1] * other[2] - self[2] * other[1]
        outputPointer.initialize(to: v0)
        let v1 = self[2] * other[0] - self[0] * other[2]
        (outputPointer + 1).initialize(to: v1)
        let v2 = self[0] * other[1] - self[1] * other[0]
        (outputPointer + 2).initialize(to: v2)
        
        return .init(SharedPointer(outputPointer), outputSize)
    }
}
