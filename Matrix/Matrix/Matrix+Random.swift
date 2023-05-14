//
//  Matrix+Random.swift
//  ClothSimulation
//
//  Created by Reza on 1/16/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public static func Random(_ rows: Int = Self.Rows, _ cols: Int = Self.Cols) -> Self where Element == Double {
        let size: MatrixSize = [rows, cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            (pointer + i).initialize(to: Double.random(in: -1...1.0))
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public static func Random(_ rows: Int = Self.Rows, _ cols: Int = Self.Cols) -> Self where Element == Float {
        let size: MatrixSize = [rows, cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            (pointer + i).initialize(to: Float.random(in: -1...1.0))
        }
        
        return .init(SharedPointer(pointer), size)
    }
    /*
    static func Random(_ rows: Int = Self.Rows, _ cols: Int = Self.Cols) -> Self where Element == Float80 {
        let size: MatrixSize = [rows, cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        for i in 0..<size.count {
            (pointer + i).initialize(to: Float80.random(in: -1...1.0))
        }
        
        return .init(SharedPointer(pointer), size)
    }*/
}
