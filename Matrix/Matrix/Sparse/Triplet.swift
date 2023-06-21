//
//  Triplet.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Triplet<T: MatrixElement> {
    var i: Int
    var j: Int
    var value: T
    
    public init(i: Int, j: Int, value: T) {
        self.i = i
        self.j = j
        self.value = value
    }
}

extension Triplet: Comparable {
    public static func < (lhs: Triplet<T>, rhs: Triplet<T>) -> Bool {
        if lhs.i < rhs.i {
            return true
        } else {
            if lhs.i == rhs.i {
                return lhs.j <= rhs.j
            }
            return false
        }
    }
    
    public static func == (lhs: Triplet<T>, rhs: Triplet<T>) -> Bool {
        return lhs.i == rhs.i && lhs.j == rhs.j
    }
}
