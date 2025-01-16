//
//  Matrix+clone.swift
//  Matrix
//
//  Created by Reza on 1/16/25.
//

import Foundation

extension Matrix {
    public func clone() -> Self {
        let ptr: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        return Self.init(SharedPointer(ptr), [rows, cols])
    }
}
