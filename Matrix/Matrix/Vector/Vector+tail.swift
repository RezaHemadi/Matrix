//
//  Vector+tail.swift
//  Fashionator
//
//  Created by Reza on 4/25/23.
//

import Foundation

extension Vector {
    public func tail(_ n: Int) -> MatrixBlock<Element> {
        // Make sure n is smaller than vector size
        assert(n <= size.count)
        
        let blockSize: MatrixSize = [rows == 1 ? 1 : n, cols == 1 ? 1 : n]
        let blockCount: Int = blockSize.count
        let myCount: Int = count
        
        var values = [UnsafeMutablePointer<Element>]()
        values.reserveCapacity(blockSize.count)
        
        for i in 0..<blockCount {
            let t = blockCount - i
            values.append(valuesPtr.pointer + myCount - t)
        }
        
        return .init(values: values, size: blockSize)
    }
}
