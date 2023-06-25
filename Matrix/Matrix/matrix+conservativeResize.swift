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
    }
}
