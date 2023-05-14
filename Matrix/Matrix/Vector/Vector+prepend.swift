//
//  Vector+prepend.swift
//  Fashionator
//
//  Created by Reza on 4/21/23.
//

import Foundation

extension Vector {
    public mutating func prepend(_ value: Element, count: Int = 1) {
        // allocate a new pointer
        let newPtr: UnsafeMutablePointer<Element> = .allocate(capacity: size.count + count)
        newPtr.initialize(repeating: value, count: count)
        (newPtr + count).moveInitialize(from: valuesPtr.pointer, count: size.count)
        valuesPtr = .init(newPtr)
        size = .init(Self.Rows == 1 ? 1 : size.count + count,
                     Self.Cols == 1 ? 1 : size.count + count)
    }
}
