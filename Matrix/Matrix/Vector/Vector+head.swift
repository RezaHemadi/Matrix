//
//  Vector+head.swift
//  ClothSimulation
//
//  Created by Reza on 1/21/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Vector {
    public func head(_ n: Int) -> MatrixBlock<Element> {
        // Make sure n is smaller than vector size
        assert(n <= size.count)
        
        /*
        let blockSize: MatrixSize = [rows == 1 ? 1 : n, cols == 1 ? 1 : n]
        
        var values = [UnsafeMutablePointer<Element>]()
        values.reserveCapacity(blockSize.count)
        
        for i in 0..<blockSize.count {
            values.append(valuesPtr.pointer + i)
        }
        
        return .init(values: values, size: blockSize)*/
        
        let blockRows: Int = rows == 1 ? 1 : n
        let blockCols: Int = cols == 1 ? 1 : n
        
        let indexFinder: IndexFinder = { (i, j) -> Int in
            let index = (i == 1 ? j : i)
            return index
        }
        
        return .init(values: valuesPtr.pointer, indexFinder: indexFinder, rows: blockRows, cols: blockCols)
    }
}
