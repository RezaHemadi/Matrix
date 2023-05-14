//
//  Matrix+Col.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public func col(_ j: Int) -> MatrixColumn<Element> {
        assert(j < cols)
        
        var pointers: [UnsafeMutablePointer<Element>] = []
        
        for i in 0..<rows {
            let elementIndex = elementIndex(i: i, j: j, size: size)
            pointers.append(valuesPtr.pointer + elementIndex)
        }
        
        return .init(values: pointers)
    }
    
    public func col<V: Vector>(_ j: Int) -> V where V.Element == Element {
        let size: MatrixSize = [V.Rows == 1 ? 1 : rows,
                                V.Cols == 1 ? 1 : rows]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        for i in 0..<rows {
            (pointer + i).initialize(to: self[i, j])
        }
        //let startIndex = elementIndex(i: 0, j: j, size: self.size)
        //pointer.initialize(from: valuesPtr.pointer + startIndex, count: rows)
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func col(_ j: Int) -> ColType where ColType: Vector, ColType.Element == Element {
        typealias V = ColType
        let size: MatrixSize = [V.Rows == 1 ? 1 : rows,
                                V.Cols == 1 ? 1 : rows]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        for i in 0..<rows {
            (pointer + i).initialize(to: self[i, j])
        }
        //let startIndex = elementIndex(i: 0, j: j, size: self.size)
        //pointer.initialize(from: valuesPtr.pointer + startIndex, count: rows)
        
        return .init(SharedPointer(pointer), size)
    }
}
