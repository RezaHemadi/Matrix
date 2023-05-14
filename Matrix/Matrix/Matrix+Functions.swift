//
//  Matrix+Functions.swift
//  ClothSimulation
//
//  Created by Reza on 1/22/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

// an expression of the coefficient-wise square root of m
/*
func sqrt<M1: Matrix, M2: Matrix>(_ m: M1) -> M2 where M1.Element == M2.Element, M1.Element == Double {
    typealias S = M1.Element
    let size = m.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = Darwin.sqrt(m.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}*/

public func sqrt<M1: Matrix>(_ m: M1) -> M1 where M1.Element == Double {
    typealias S = M1.Element
    let size = m.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = Darwin.sqrt(m.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func sqrt<M: Matrix>(_ a: MatrixArray<Double>) -> M where M.Element == Double {
    let size = a.size
    let pointer: UnsafeMutablePointer<Double> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value = Darwin.sqrt(a.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func sqrt<M: Matrix>(_ a: MatrixArray<Float>) -> M where M.Element == Float {
    let size = a.size
    let pointer: UnsafeMutablePointer<Float> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value = Darwin.sqrtf(a.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}
/*
func sqrt<M: Matrix>(_ a: MatrixArray<Float80>) -> M where M.Element == Float80 {
    let size = a.size
    let pointer: UnsafeMutablePointer<Float80> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value = Darwin.sqrtl(a.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}
*/
/*
func sqrt<M1: Matrix, M2: Matrix>(_ m: M1) -> M2 where M1.Element == M2.Element, M1.Element == Float {
    typealias S = M1.Element
    let size = m.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = Darwin.sqrtf(m.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}*/

public func sqrt<M1: Matrix>(_ m: M1) -> M1 where M1.Element == Float {
    typealias S = M1.Element
    let size = m.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = Darwin.sqrtf(m.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}
/*
func sqrt<M1: Matrix, M2: Matrix>(_ m: M1) -> M2 where M1.Element == M2.Element, M1.Element == Float80 {
    typealias S = M1.Element
    let size = m.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = Darwin.sqrtl(m.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}*/
/*
func sqrt<M1: Matrix>(_ m: M1) -> M1 where M1.Element == Float80 {
    typealias S = M1.Element
    let size = m.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = Darwin.sqrtl(m.valuesPtr.pointer[i])
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}
*/
