//
//  Matrix+Algebra.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

// MARK: - Addition
public func +<M1: Matrix, M2: Matrix>(lhs: M1, rhs: M2) -> M1 where M1.Element == M2.Element, M1.Element: AdditiveArithmetic {
    assert(lhs.size == rhs.size)
    
    let valuesPtr: UnsafeMutablePointer<M1.Element> = .allocate(capacity: lhs.size.count)
    
    for i in 0..<lhs.size.count {
        (valuesPtr + i).initialize(to: lhs.valuesPtr.pointer[i] + rhs.valuesPtr.pointer[i])
    }
    
    return .init(SharedPointer(valuesPtr), lhs.size)
}

public func +=<M1: Matrix, M2: Matrix>(lhs: inout M1, rhs: M2) where M1.Element == M2.Element, M1.Element: AdditiveArithmetic {
    assert(lhs.size == rhs.size)
    
    for i in 0..<lhs.size.count {
        lhs.valuesPtr.pointer[i] += rhs.valuesPtr.pointer[i]
    }
}

// MARK: - Subtraction
public func -<M1: Matrix, M2: Matrix>(lhs: M1, rhs: M2) -> M1 where M1.Element == M2.Element, M1.Element: AdditiveArithmetic {
    assert(lhs.size == rhs.size)
    
    let valuesPtr: UnsafeMutablePointer<M1.Element> = .allocate(capacity: lhs.size.count)
    
    for i in 0..<lhs.size.count {
        (valuesPtr + i).initialize(to: lhs.valuesPtr.pointer[i] - rhs.valuesPtr.pointer[i])
    }
    
    return .init(SharedPointer(valuesPtr), lhs.size)
}

public func -=<M1: Matrix, M2: Matrix>(lhs: inout M1, rhs: M2) where M1.Element == M2.Element, M1.Element: AdditiveArithmetic {
    assert(lhs.size == rhs.size)
    
    for i in 0..<lhs.size.count {
        lhs.valuesPtr.pointer[i] -= rhs.valuesPtr.pointer[i]
    }
}

public prefix func -<M: Matrix>(_ m: M) -> M where M.Element: SignedNumeric {
    /*
    var values = [M.Element]()
    values.reserveCapacity(m.size.count)
    
    for i in 0..<m.size.count {
        values.append(-m.valuesPtr.pointer[i])
    }
    
    return .init(values, m.size)*/
    let ptr: UnsafeMutablePointer<M.Element> = .allocate(capacity: m.size.count)
    for i in 0..<m.size.count {
        (ptr + i).initialize(to: -m.valuesPtr.pointer[i])
    }
    
    return .init(SharedPointer(ptr), m.size)
}

// MARK: - Multiplication
public func *<M1: Matrix, M2: Matrix, S: Numeric>(lhs: M1, rhs: M2) -> Mat<S> where M1.Element == M2.Element, M1.Element == S {
    // Make sure operands size are compatible
    assert(lhs.size.cols == rhs.size.rows)
    
    let ptr: UnsafeMutablePointer<S> = .allocate(capacity: lhs.rows * rhs.cols)
    
    // Determine size of output
    //var output = Mat<S>(lhs.size.rows, rhs.size.cols)
    
    var n: Int = 0
    for i in 0..<lhs.size.rows {
        for j in 0..<rhs.size.cols {
            var sum: S = .zero
            for t in 0..<lhs.size.cols {
                let t0 = lhs.size.cols * i
                sum += lhs.valuesPtr.pointer[t0 + t] * rhs.valuesPtr.pointer[rhs.size.cols * t + j]
                //sum += (lhs[i, t] * rhs[t, j])
            }
            //output[i, j] = sum
            (ptr + n).initialize(to: sum)
            n += 1
        }
    }
    
    return .init(SharedPointer(ptr), [lhs.size.rows, rhs.size.cols])
    //return output
}

public func *<M1: Matrix, M2: Matrix, M3: Matrix>(lhs: M1, rhs: M2) -> M3 where M1.Element == M2.Element, M1.Element == M3.Element, M1.Element: Numeric {
    typealias S = M1.Element
    
    // Make sure operands size are compativle
    assert(lhs.size.cols == rhs.size.rows)
    
    let ptr: UnsafeMutablePointer<S> = .allocate(capacity: lhs.rows * rhs.cols)
    
    // determine size of output
    //var output: M3 = .init(lhs.size.rows, rhs.size.cols)
    var n: Int = 0
    for i in 0..<lhs.size.rows {
        for j in 0..<rhs.size.cols {
            var sum: S = .zero
            
            for t in 0..<lhs.size.cols {
                let t0 = lhs.size.cols * i
                sum += lhs.valuesPtr.pointer[t0 + t] * rhs.valuesPtr.pointer[rhs.size.cols * t + j]
                //sum += (lhs[i, t] * rhs[t, j])
            }
            (ptr + n).initialize(to: sum)
            //output[i, j] = sum
            n += 1
        }
    }
    return .init(SharedPointer(ptr), [lhs.size.rows, rhs.size.cols])
    //return output
}

public func *<M: Matrix, S: Numeric>(lhs: M, rhs: S) -> M where M.Element == S {
    /*
    var values = [S]()
    values.reserveCapacity(lhs.size.count)
    
    for i in 0..<lhs.size.count {
        values.append(lhs.valuesPtr.pointer[i] * rhs)
    }
    
    return .init(values, lhs.size)*/
    
    let ptr: UnsafeMutablePointer<S> = .allocate(capacity: lhs.size.count)
    
    for i in 0..<lhs.size.count {
        (ptr + i).initialize(to: lhs.valuesPtr.pointer[i] * rhs)
    }
    
    return .init(SharedPointer(ptr), lhs.size)
}

public func *<M: Matrix, S: Numeric>(lhs: S, rhs: M) -> M where M.Element == S {
    /*
    var values = [S]()
    values.reserveCapacity(rhs.size.count)
    
    for i in 0..<rhs.size.count {
        values.append(rhs.valuesPtr.pointer[i] * lhs)
    }
    
    return .init(values, rhs.size)*/
    
    let ptr: UnsafeMutablePointer<S> = .allocate(capacity: rhs.size.count)
    
    for i in 0..<rhs.size.count {
        (ptr + i).initialize(to: lhs * rhs.valuesPtr.pointer[i])
    }
    
    return .init(SharedPointer(ptr), rhs.size)
}

public func *<M1: Matrix, S: Numeric, M2: Matrix>(lhs: S, rhs: M1) -> M2 where M1.Element == M2.Element, M1.Element == S {
    let size: MatrixSize = rhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = rhs.valuesPtr.pointer[i] * lhs
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func *<M1: Matrix, S: Numeric, M2: Matrix>(lhs: M1, rhs: S) -> M2 where M1.Element == M2.Element, M1.Element == S {
    let size: MatrixSize = lhs.size
    let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
    
    for i in 0..<size.count {
        let value: S = lhs.valuesPtr.pointer[i] * rhs
        (pointer + i).initialize(to: value)
    }
    
    return .init(SharedPointer(pointer), size)
}

public func *=<M: Matrix, S: Numeric>(lhs: inout M, rhs: S) where M.Element == S {
    for i in 0..<lhs.size.count {
        lhs.valuesPtr.pointer[i] *= rhs
    }
}

// MARK: - Division
public func /<M: Matrix, S: FloatingPoint>(lhs: M, rhs: S) -> M where M.Element == S {
    /*var values = [S]()
    values.reserveCapacity(lhs.size.count)*/
    
    let valuesPtr: UnsafeMutablePointer<S> = .allocate(capacity: lhs.size.count)
    
    
    for i in 0..<lhs.size.count {
        (valuesPtr + i).initialize(to: lhs.valuesPtr.pointer[i] / rhs)
    }
    
    return .init(SharedPointer(valuesPtr), lhs.size)
}

public func /=<M: Matrix, S: FloatingPoint>(lhs: inout M, rhs: S) where M.Element == S {
    for i in 0..<lhs.size.count {
        lhs.valuesPtr.pointer[i] /= rhs
    }
}
