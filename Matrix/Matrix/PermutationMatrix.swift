//
//  PermutationMatrix.swift
//  ClothSimulation
//
//  Created by Reza on 1/24/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct PermutationMatrix {
    // MARK: - Properties
    public var values: [Int]
    
    // MARK: - Initialization
    public init<V: Vector>(_ v: V) where V.Element == Int {
        values = []
        values.reserveCapacity(v.count)
        
        for i in 0..<v.count {
            values.append(v[i])
        }
    }
}

public func *<M: Matrix>(lhs: M, rhs: PermutationMatrix) -> M {
    typealias S = M.Element
    
    // Interchange lhs columns according to permutation vector
    let size: MatrixSize = lhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for j in 0..<size.cols {
        let colIndex = rhs.values[j]
        for i in 0..<size.rows {
            let elementIndex = elementIndex(i: i, j: colIndex, size: size)
            (pointer + elementIndex).initialize(to: lhs[i, j])
        }
    }
    
    return .init(SharedPointer(pointer), size)
}
