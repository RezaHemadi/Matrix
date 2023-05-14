//
//  Matrix+cast.swift
//  ClothSimulation
//
//  Created by Reza on 1/19/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public func castToInt<M: Matrix>() -> M where Element == Double, M.Element == Int {
        let size = self.size
        let pointer: UnsafeMutablePointer<Int> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Int(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func castToInt<M: Matrix>() -> M where Element == Float, M.Element == Int {
        let size = self.size
        let pointer: UnsafeMutablePointer<Int> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Int(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func castToInt<M: Matrix>() -> M where Element == UInt32, M.Element == Int {
        let size = self.size
        let pointer: UnsafeMutablePointer<Int> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Int(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    /*
    func castToInt<M: Matrix>() -> M where Element == Float80, M.Element == Int {
        let size = self.size
        let pointer: UnsafeMutablePointer<Int> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Int(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }*/
    
    public func castToDouble<M: Matrix>() -> M where Element == Int, M.Element == Double {
        let size = self.size
        let pointer: UnsafeMutablePointer<Double> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Double(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func castToDouble<M: Matrix>() -> M where Element == Float, M.Element == Double {
        let size = self.size
        let pointer: UnsafeMutablePointer<Double> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Double(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    /*
    func castToDouble<M: Matrix>() -> M where Element == Float80, M.Element == Double {
        let size = self.size
        let pointer: UnsafeMutablePointer<Double> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Double(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }*/
    
    public func castToFloat<M: Matrix>() -> M where Element == Double, M.Element == Float {
        let size = self.size
        let pointer: UnsafeMutablePointer<Float> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = Float(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public func castToUInt32<M: Matrix>() -> M where Element == Int, M.Element == UInt32 {
        let size = self.size
        let pointer: UnsafeMutablePointer<UInt32> = .allocate(capacity: size.count)
        for i in 0..<size.count {
            let value = UInt32(valuesPtr.pointer[i])
            pointer[i] = value
        }
        
        return .init(SharedPointer(pointer), size)
    }
}
