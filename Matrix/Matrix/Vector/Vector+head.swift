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
        
        let blockSize: MatrixSize = [rows == 1 ? 1 : n, cols == 1 ? 1 : n]
        
        var values = [UnsafeMutablePointer<Element>]()
        values.reserveCapacity(blockSize.count)
        
        for i in 0..<blockSize.count {
            values.append(valuesPtr.pointer + i)
        }
        
        return .init(values: values, size: blockSize)
    }
}
