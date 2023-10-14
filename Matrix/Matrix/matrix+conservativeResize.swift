//
//  matrix+conservativeResize.swift
//  Matrix
//
//  Created by Reza on 6/25/23.
//

import Foundation

extension Matrix {
    // Resizes the matrix to rows x cols while leaving old values untouched.
    // Matrices are resized relative to the top-left element.
    // In case values need to be appended to the matrix they will be uninitialized.
    /*
    public mutating func conservativeResize(_ rows: Int, _ cols: Int) {
        // don't allow static size matrices to resize to other sizes
        
        // check rows
        if (Self.Rows != 0) {
            assert(Self.Rows == rows)
        }
        
        // check columns
        if (Self.Cols != 0) {
            assert(Self.Cols == cols)
        }
        
        let newCount: Int = rows * cols
        
        if (newCount < size.count) {
            // don't touch the pointer, only change the size
            size = [rows, cols]
        } else {
            // allocate new pointer with appropriate size
            let newPtr: UnsafeMutablePointer<Element> = .allocate(capacity: newCount)
            newPtr.moveInitialize(from: valuesPtr.pointer, count: size.count)
            self.valuesPtr = .init(newPtr)
            self.size = [rows, cols]
        }
    }*/
    
    public mutating func conservativeResize(_ rows: Int, _ cols: Int) {
        assert(rows != 0 && cols != 0)
        // don't allow static size matrices to resize to other sizes
        
        // check rows
        if (Self.Rows != 0) {
            assert(Self.Rows == rows)
        }
        
        // check columns
        if (Self.Cols != 0) {
            assert(Self.Cols == cols)
        }
        
        // if we are dealing with vectors
        if (self.rows == 1 || self.cols == 1) {
            if (rows == 1 || cols == 1) {
                let newSize: MatrixSize = [rows, cols]
                let newValuesPtr: UnsafeMutablePointer<Element> = .allocate(capacity: newSize.count)
                
                newValuesPtr.moveInitialize(from: self.valuesPtr.pointer, count: size.count)
                let diff: Int = newSize.count - size.count
                if diff > 0 {
                    (newValuesPtr + size.count).initialize(repeating: .init(), count: diff)
                }
                self.size = newSize
                self.valuesPtr = .init(newValuesPtr)
                
                return
            }
        }
        
        // If we are adding rows
        if self.cols == cols {
            let newSize: MatrixSize = [rows, cols]
            let newValuesPtr: UnsafeMutablePointer<Element> = .allocate(capacity: newSize.count)
            
            newValuesPtr.moveInitialize(from: self.valuesPtr.pointer, count: size.count)
            let diff: Int = newSize.count - size.count
            if diff > 0 {
                (newValuesPtr + size.count).initialize(repeating: .init(), count: diff)
            }
            self.size = newSize
            self.valuesPtr = .init(newValuesPtr)
            
            return
        }
        
        let newSize: MatrixSize = [rows, cols]
        let newValuesPtr: UnsafeMutablePointer<Element> = .allocate(capacity: newSize.count)
        
        for i in 0..<rows {
            for j in 0..<cols {
                let elementIndex = elementIndex(i: i, j: j, size: newSize)
                if i < self.rows && j < self.cols {
                    // copy value from old
                    (newValuesPtr + elementIndex).initialize(to: self[i, j])
                } else {
                    (newValuesPtr + elementIndex).initialize(to: .init())
                }
            }
        }
        
        self.size = newSize
        self.valuesPtr = .init(newValuesPtr)
    }
}
