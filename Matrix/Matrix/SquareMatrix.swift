//
//  SquareMatrix.swift
//  ClothSimulation
//
//  Created by Reza on 1/24/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public protocol SquareMatrix {}

extension SquareMatrix where Self: Matrix, Element: ExpressibleByIntegerLiteral {
    public static func identity() -> Self {
        let size: MatrixSize = [Self.Rows, Self.Cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        for j in 0..<size.cols {
            for i in 0..<size.rows {
                let index = elementIndex(i: i, j: j, size: size)
                let value: Element = (i == j) ? 1 : 0
                (pointer + index).initialize(to: value)
            }
        }
        
        return .init(SharedPointer(pointer), size)
    }
}
