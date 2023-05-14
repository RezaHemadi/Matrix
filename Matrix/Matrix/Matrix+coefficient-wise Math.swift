//
//  Matrix+coefficient-wise Math.swift
//  ClothSimulation
//
//  Created by Reza on 1/25/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public func cwiseAbs() -> Self where Element: Comparable & SignedNumeric {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value: Element = abs(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func cwiseAbs2() -> Self where Element: Comparable & SignedNumeric {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value: Element = abs(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value * value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func cwiseQuotient<M: Matrix>(_ other: M) -> Self where M.Element == Element, Element: FloatingPoint {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            let myValue = valuesPtr.pointer[i]
            let otherValue = other.valuesPtr.pointer[i]
            let quotient = myValue / otherValue
            (pointer + i).initialize(to: quotient)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func cwiseInverse() -> Self where Element: FloatingPoint & ExpressibleByFloatLiteral {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            let value: Element = 1.0 / valuesPtr.pointer[i]
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func cwiseProduct<M: Matrix>(_ other: M) -> Self where M.Element == Element, Element: Numeric {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = valuesPtr.pointer[i] * other.valuesPtr.pointer[i]
            (pointer + i).initialize(to: value)
        }
        return .init(SharedPointer(pointer), size)
    }
}
