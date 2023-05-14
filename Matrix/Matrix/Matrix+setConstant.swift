//
//  Matrix+setConstant.swift
//  Fashionator
//
//  Created by Reza on 4/20/23.
//

import Foundation

extension Matrix {
    public mutating func setConstant(_ rows: Int, _ cols: Int, _ value: Element) {
        resize(rows, cols)
        valuesPtr.pointer.initialize(repeating: value, count: size.count)
    }
    
    public mutating func setConstant(_ value: Element) {
        valuesPtr.pointer.initialize(repeating: value, count: size.count)
    }
}
