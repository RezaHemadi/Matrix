//
//  Matrix+Equatable.swift
//  Matrix
//
//  Created by Reza on 8/9/23.
//

import Foundation

public func ==<MLHS: Matrix, MRHS: Matrix>(lhs: MLHS, rhs: MRHS) -> Bool where MLHS.Element == MRHS.Element {
    guard lhs.size == rhs.size else { return false }
    
    for i in 0..<lhs.size.count {
        if lhs.valuesPtr.pointer[i] != rhs.valuesPtr.pointer[i] {
            return false
        }
    }
    return true
}
