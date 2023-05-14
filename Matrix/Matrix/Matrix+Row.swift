//
//  Matrix+Row.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public func row(_ i: Int) -> MatrixRow<Element> {
        assert(i < rows)
        
        var values = [UnsafeMutablePointer<Element>]()
        values.reserveCapacity(cols)
        
        for j in 0..<cols {
            let elementIndex = elementIndex(i: i, j: j, size: size)
            values.append(valuesPtr.pointer + elementIndex)
        }
        
        return .init(values: values)
    }
    
    public func row<V: Vector>(_ i: Int) -> V where V.Element == Element {
        let outputSize: MatrixSize = [V.Rows == 1 ? 1 : cols,
                                      V.Cols == 1 ? 1 : cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: outputSize.count)
        
        for j in 0..<cols {
            (pointer + j).initialize(to: self[i, j])
        }
        
        return .init(SharedPointer(pointer), outputSize)
    }
    
    public func row(_ i: Int) -> RowType where RowType: Vector, RowType.Element == Element {
        typealias V = RowType
        let size: MatrixSize = [V.Rows == 1 ? 1 : cols,
                                V.Cols == 1 ? 1 : cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: cols)
        for j in 0..<cols {
            (pointer + j).initialize(to: self[i, j])
        }
        
        return .init(SharedPointer(pointer), size)
    }
}
