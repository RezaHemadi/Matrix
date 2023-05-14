//
//  Matrix+ptrRef.swift
//  Fashionator
//
//  Created by Reza on 4/22/23.
//

import Foundation

extension Matrix {
    public func ptrRef(_ i: Int, _ j: Int) -> UnsafeMutablePointer<Element> {
        assert(i < rows)
        assert(j < cols)
        
        let index = elementIndex(i: i, j: j, size: size)
        return (valuesPtr.pointer + index)
    }
}
