//
//  Vector+Operators.swift
//  ClothSimulation
//
//  Created by Reza on 1/21/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public func +<V1: Vector, V2: Vector, V3: Vector>(lhs: V1, rhs: V2) -> V3 where V1.Element == V2.Element, V1.Element == V3.Element, V1.Element: AdditiveArithmetic {
    assert(lhs.count == rhs.count)
    typealias S = V1.Element
    
    let size: MatrixSize = [V3.Rows == 1 ? 1 : lhs.count,
                            V3.Cols == 1 ? 1 : lhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value = lhs[i] + rhs[i]
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func -<V1: Vector, V2: Vector, V3: Vector>(lhs: V1, rhs: V2) -> V3 where V1.Element == V2.Element, V1.Element == V3.Element, V1.Element: SignedNumeric {
    assert(lhs.count == rhs.count)
    typealias S = V1.Element
    
    let size: MatrixSize = [V3.Rows == 1 ? 1 : lhs.count,
                            V3.Cols == 1 ? 1 : lhs.count]
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value = lhs[i] - rhs[i]
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}
