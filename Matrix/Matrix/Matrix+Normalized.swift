//
//  Matrix+Normalized.swift
//  ClothSimulation
//
//  Created by Reza on 1/21/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public func normalized<M: Matrix>() -> M where Element == Double, M.Element == Element {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        let norm = self.norm()
        
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i] / norm
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func normalized() -> Self where Element == Double {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        let norm = self.norm()
        
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i] / norm
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func normalized<M: Matrix>() -> M where Element == Float, M.Element == Element {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        let norm = self.norm()
        
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i] / norm
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func normalized() -> Self where Element == Float {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        let norm = self.norm()
        
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i] / norm
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
}
