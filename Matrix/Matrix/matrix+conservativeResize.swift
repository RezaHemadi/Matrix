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
        guard (rows != self.rows || cols != self.cols) else { return }
        
        assert(rows != 0 && cols != 0)
        // don't allow static size matrices to resize to other sizes
        
        #if DEBUG
        // check rows
        if (Self.Rows != 0) {
            assert(Self.Rows == rows)
        }
        
        // check columns
        if (Self.Cols != 0) {
            assert(Self.Cols == cols)
        }
        #endif
        
        // if we are dealing with vectors
        if (self.rows == 1 || self.cols == 1) {
            if (rows == 1 || cols == 1) {
                let newSize: MatrixSize = [rows, cols]
                
                let n = newSize.count
                
                if n > capacity {
                    // allocate new memory
                    let newValuesPtr: UnsafeMutablePointer<Element> = .allocate(capacity: n)
                    capacity = n
                    let oldN = size.count
                    newValuesPtr.initialize(from: valuesPtr.pointer, count: oldN)
                    let diff: Int = n - oldN
                    if diff > 0 {
                        (newValuesPtr + oldN).initialize(repeating: .init(), count: diff)
                    }
                    size = newSize
                    valuesPtr = .init(newValuesPtr)
                } else {
                    // no need to allocate new memory
                    size = newSize
                }
                
                return
            }
        }
        
        // If we are adding rows
        if self.cols == cols {
            let newSize: MatrixSize = [rows, cols]
            let n = newSize.count
            
            if n > capacity {
                // allocate new memory
                let newValuesPtr: UnsafeMutablePointer<Element> = .allocate(capacity: n)
                capacity = n
                let oldN = size.count
                newValuesPtr.initialize(from: valuesPtr.pointer, count: oldN)
                let diff: Int = n - oldN
                if diff > 0 {
                    (newValuesPtr + oldN).initialize(repeating: .init(), count: diff)
                }
                size = newSize
                valuesPtr = .init(newValuesPtr)
            } else {
                // no need to allocate new memory
                size = newSize
            }
            
            return
        }
        
        let newSize: MatrixSize = [rows, cols]
        
        let newValuesPtr: UnsafeMutablePointer<Element> = .allocate(capacity: newSize.count)
        capacity = newSize.count
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
