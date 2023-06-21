//
//  MatrixArray.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct MatrixArray<T: MatrixElement> {
    // MARK: - Properties
    let valuesPtr: SharedPointer<T>
    let size: MatrixSize
    
    // MARK: - Subscript
    subscript(_ i: Int, _ j: Int) -> UnsafeMutablePointer<T> {
        get {
            let index = elementIndex(i: i, j: j, size: size)
            return valuesPtr.pointer + index
        }
    }
    
    // MARK: - Methods
    public func square() -> Self where T: Numeric {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            (pointer + i).initialize(to: valuesPtr.pointer[i] * valuesPtr.pointer[i])
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    public func sqrt() -> Self where T == Double {
        let pointer: UnsafeMutablePointer<Double> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            (pointer + i).initialize(to: Darwin.sqrt(valuesPtr.pointer[i]))
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    public func sqrt() -> Self where T == Float {
        let pointer: UnsafeMutablePointer<Float> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            (pointer + i).initialize(to: Darwin.sqrtf(valuesPtr.pointer[i]))
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    /*
    func sqrt() -> Self where T == Float80 {
        let pointer: UnsafeMutablePointer<Float80> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            (pointer + i).initialize(to: Darwin.sqrtl(valuesPtr.pointer[i]))
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }*/
    
    public func cwiseAbs() -> Self where T: Comparable & SignedNumeric {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            (pointer + i).initialize(to: abs(valuesPtr.pointer[i]))
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    public func maxCoeff() -> T where T: Comparable {
        var max: T = valuesPtr.pointer[0]
        
        for i in 1..<size.count {
            if valuesPtr.pointer[i] > max {
                max = valuesPtr.pointer[i]
            }
        }
        
        return max
    }
    
    public func minCoeff() -> T where T: Comparable {
        var min: T = valuesPtr.pointer[0]
        
        for i in 1..<size.count {
            if valuesPtr.pointer[i] < min {
                min = valuesPtr.pointer[i]
                
            }
        }
        
        return min
    }
    
    public func pow(_ a: T) -> MatrixArray<T> where T == Double {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.pow(valuesPtr.pointer[i], a)
            (pointer + i).initialize(to: value)
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    public func pow(_ a: T) -> MatrixArray<T> where T == Float {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.powf(valuesPtr.pointer[i], a)
            (pointer + i).initialize(to: value)
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    /*
    func pow(_ a: T) -> MatrixArray<T> where T == Float80 {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.powl(valuesPtr.pointer[i], a)
            (pointer + i).initialize(to: value)
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }*/
    
    public func log() -> MatrixArray<T> where T == Double {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.log(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    public func log<M: Matrix>() -> M where M.Element == T, T == Double {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.log(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func log() -> MatrixArray<T> where T == Float {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.logf(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    public func log<M: Matrix>() -> M where M.Element == T, T == Float {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.logf(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    /*
    func log() -> MatrixArray<T> where T == Float80 {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.logl(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        
        return .init(valuesPtr: SharedPointer(pointer), size: size)
    }
    
    func log<M: Matrix>() -> M where M.Element == T, T == Float80 {
        let pointer: UnsafeMutablePointer<T> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Darwin.logl(valuesPtr.pointer[i])
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }*/
}
