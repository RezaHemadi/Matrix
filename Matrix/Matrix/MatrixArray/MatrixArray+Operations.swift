//
//  MatrixArray+Operations.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

// MARK: - Addition
public func +<S: AdditiveArithmetic>(lhs: MatrixArray<S>, rhs: S) -> MatrixArray<S> {
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: lhs.size.count)
    
    for i in 0..<lhs.size.count {
        (pointer + i).initialize(to: lhs.valuesPtr.pointer[i] + rhs)
    }
    
    return .init(valuesPtr: SharedPointer(pointer), size: lhs.size)
}

public func +<S: AdditiveArithmetic>(lhs: S, rhs: MatrixArray<S>) -> MatrixArray<S> {
    let pointer = UnsafeMutablePointer<S>.allocate(capacity: rhs.size.count)
    
    for i in 0..<rhs.size.count {
        (pointer + i).initialize(to: rhs.valuesPtr.pointer[i] + lhs)
    }
    
    return .init(valuesPtr: SharedPointer(pointer), size: rhs.size)
}

public func +<S: MatrixElement & AdditiveArithmetic>(lhs: MatrixArray<S>, rhs: MatrixArray<S>) -> MatrixArray<S> {
    assert(lhs.size == rhs.size)
    
    let pointer = UnsafeMutablePointer<S>.allocate(capacity: lhs.size.count)
    
    for i in 0..<lhs.size.count {
        (pointer + i).initialize(to: lhs.valuesPtr.pointer[i] + rhs.valuesPtr.pointer[i])
    }
    
    return .init(valuesPtr: SharedPointer(pointer), size: lhs.size)
}

public func +<S: MatrixElement & AdditiveArithmetic, M: Matrix>(lhs: MatrixArray<S>, rhs: S) -> M where M.Element == S {
    let size = lhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value = lhs.valuesPtr.pointer[i] + rhs
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}
/*
func +=<M: Matrix, S: AdditiveArithmetic>(lhs: MatrixArray<M>, rhs: S) where M.Element == S {
    for i in 0..<lhs.size.count {
        (lhs.valuesPtr.pointer + i).pointee += rhs
    }
}*/

// MARK: - Subtraction
public func -<S: SignedNumeric>(lhs: MatrixArray<S>, rhs: S) -> MatrixArray<S> {
    let size = lhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = lhs.valuesPtr.pointer[i] - rhs
        (pointer + i).initialize(to: value)
    }
    
    return MatrixArray<S>(valuesPtr: SharedPointer(pointer), size: size)
}

public func -<S: SignedNumeric>(lhs: MatrixArray<S>, rhs: MatrixArray<S>) -> MatrixArray<S> {
    assert(lhs.size == rhs.size)
    
    let size = lhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = lhs.valuesPtr.pointer[i] - rhs.valuesPtr.pointer[i]
        (pointer + i).initialize(to: value)
    }
    
    return MatrixArray<S>(valuesPtr: SharedPointer(pointer), size: size)
}

public prefix func -<S: SignedNumeric>(_ a: MatrixArray<S>) -> MatrixArray<S> {
    let size = a.size
    
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = -a.valuesPtr.pointer[i]
        (pointer + i).initialize(to: value)
    }
    
    return MatrixArray<S>(valuesPtr: SharedPointer(pointer), size: size)
}

public func -<S: MatrixElement & SignedNumeric, M: Matrix>(lhs: S, rhs: MatrixArray<S>) -> M where M.Element == S {
    let size: MatrixSize = rhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = lhs - rhs.valuesPtr.pointer[i]
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

// MARK: - Multiplication
public func *<S: Numeric>(lhs: MatrixArray<S>, rhs: S) -> MatrixArray<S> {
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: lhs.size.count)
    
    for i in 0..<lhs.size.count {
        (pointer + i).initialize(to: lhs.valuesPtr.pointer[i] * rhs)
    }
    
    return .init(valuesPtr: SharedPointer(pointer), size: lhs.size)
}

public func *<S: Numeric>(lhs: S, rhs: MatrixArray<S>) -> MatrixArray<S> {
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: rhs.size.count)
    
    for i in 0..<rhs.size.count {
        (pointer + i).initialize(to: rhs.valuesPtr.pointer[i] * lhs)
    }
    
    return .init(valuesPtr: SharedPointer(pointer), size: rhs.size)
}

public func *<S: Numeric>(lhs: MatrixArray<S>, rhs: MatrixArray<S>) -> MatrixArray<S> {
    assert(lhs.size == rhs.size)
    
    let size = lhs.size
    let pointer = UnsafeMutablePointer<S>.allocate(capacity: size.count)
    
    for i in 0..<size.count {
        (pointer + i).initialize(to: (lhs.valuesPtr.pointer[i] * rhs.valuesPtr.pointer[i]))
    }
    
    return .init(valuesPtr: SharedPointer(pointer), size: lhs.size)
}
/*
func *=<M: Matrix, S: Numeric>(lhs: MatrixArray<M>, rhs: S) where M.Element == S {
    for i in 0..<lhs.size.count {
        lhs.valuesPtr.pointer[i] *= rhs
    }
}

func *=<M1: Matrix, M2: Matrix>(lhs: MatrixArray<M1>, rhs: MatrixArray<M2>) where M1.Element == M2.Element, M1.Element: Numeric {
    assert(lhs.size == rhs.size)
    
    for i in 0..<lhs.size.count {
        lhs.valuesPtr.pointer[i] *= rhs.valuesPtr.pointer[i]
    }
}*/

// MARK: - Division
public func /<S: FloatingPoint>(lhs: MatrixArray<S>, rhs: S) -> MatrixArray<S> {
    let size = lhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        (pointer + i).initialize(to: lhs.valuesPtr.pointer[i] / rhs)
    }
    
    return MatrixArray<S>.init(valuesPtr: SharedPointer(pointer), size: size)
}

public func /<S: FloatingPoint, M: Matrix>(lhs: MatrixArray<S>, rhs: S) -> M where M.Element == S {
    let size = lhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = lhs.valuesPtr.pointer[i] / rhs
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

/*
func /=<M: Matrix, S: FloatingPoint>(lhs: MatrixArray<M>, rhs: S) where M.Element == S {
    for i in 0..<lhs.size.count {
        lhs.valuesPtr.pointer[i] /= rhs
    }
}*/

public func /<S: FloatingPoint>(lhs: MatrixArray<S>, rhs: MatrixArray<S>) -> MatrixArray<S> {
    assert(lhs.size == rhs.size)
    
    let size = lhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    for i in 0..<size.count {
        let value: S = lhs.valuesPtr.pointer[i] / rhs.valuesPtr.pointer[i]
        (pointer + i).initialize(to: value)
    }
    
    return MatrixArray(valuesPtr: SharedPointer(pointer), size: size)
}
/*
func /=<M1: Matrix, M2: Matrix>(lhs: MatrixArray<M1>, rhs: MatrixArray<M2>) where M1.Element == M2.Element, M1.Element: FloatingPoint {
    assert(lhs.size == rhs.size)
    typealias S = M1.Element
    
    let count = lhs.size.count
    
    for i in 0..<count {
        let value: S = lhs.valuesPtr.pointer[i] / rhs.valuesPtr.pointer[i]
        lhs.valuesPtr.pointer[i] = value
    }
}*/
