//
//  MatrixBlock+Operators.swift
//  ClothSimulation
//
//  Created by Reza on 1/25/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public func +<S: MatrixElement & AdditiveArithmetic, M: Matrix>(lhs: MatrixBlock<S>, rhs: M) -> M where M.Element == S {
    assert(lhs.size == rhs.size)
    
    let size: MatrixSize = rhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        (pointer + i).initialize(to: lhs.values[i].pointee + rhs.valuesPtr.pointer[i])
    }
    
    return .init(SharedPointer(pointer), size)
}
