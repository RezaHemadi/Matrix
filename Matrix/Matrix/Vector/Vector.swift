//
//  Vector.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public protocol Vector: Matrix, ExpressibleByArrayLiteral {
    // MARK: - Properties
    var count: Int { get }
    
    // MARK: - Initialization
    init(_: Int)
    init(_: [Element])
    static func Zero(_: Int) -> Self
    
    // MARK: - Methods
    mutating func resize(_: Int)
    mutating func conservativeResize(_: Int)
    func asDiagonal() -> Mat<Element>
    func head(_: Int) -> MatrixBlock<Element>
    mutating func prepend(_: Element, count: Int)
}

extension Vector {
    public var count: Int {
        size.count
    }
}
