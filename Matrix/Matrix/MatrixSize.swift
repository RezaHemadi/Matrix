//
//  MatrixSize.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct MatrixSize: ExpressibleByArrayLiteral, Equatable {
    public let rows: Int
    public let cols: Int
    public var count: Int
    
    public init(_ rows: Int, _ cols: Int) {
        self.rows = rows
        self.cols = cols
        count = rows * cols
    }
    
    public init(arrayLiteral elements: Int...) {
        assert(elements.count == 2)
        rows = elements[0]
        cols = elements[1]
        count = rows * cols
    }
}
