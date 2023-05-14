//
//  Matrix+unaryExpr.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    
    public func unaryExpr<M: Matrix>(_ closure: (Element) -> Element) -> M where M.Element == Element {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = closure(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        return .init(SharedPointer(pointer), size)
    }
    
    public func unaryExpr(_ closure: (Element) -> Element) -> Self {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = closure(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        return .init(SharedPointer(pointer), size)
    }
}
