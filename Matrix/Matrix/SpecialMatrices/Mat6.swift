//
//  Mat6.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct Mat6<T: MatrixElement>: Matrix {
    public typealias TransposeType = Mat6<T>
    public typealias RowType = RVec<T>
    public typealias ColType = Vec6<T>
    public static var Rows: Int { 6 }
    public static var Cols: Int { 6 }
    
    // MARK: - Properties
    public var size: MatrixSize
    public var valuesPtr: SharedPointer<T>
    
    // MARK: - Initialization
    
    public init(_ pointer: SharedPointer<T>, _ size: MatrixSize) {
        assert(size.rows == 6 && size.cols == 6)
        self.size = size
        self.valuesPtr = pointer
    }
}

extension Mat6: SquareMatrix {}
