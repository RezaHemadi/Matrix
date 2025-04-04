//
//  Matrix+Block.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public func block(_ startRow: Int, _ startCol: Int, _ blockRows: Int, _ blockCols: Int) -> MatrixBlock<Element> {
        assert(startRow >= 0 && startCol >= 0 && blockRows >= 0 && blockCols >= 0)
        assert((startRow + blockRows) <= rows && (startCol + blockCols) <= cols)
        
        // input: local i j, output global index
        let indexFinder: IndexFinder = { (i, j) -> Int in
            return (cols * (startRow + i) + startCol + j)
        }
        
        return .init(values: valuesPtr.pointer,
                     indexFinder: indexFinder, rows: blockRows, cols: blockCols)
        
    }
    
    public func block<M: Matrix>(_ startRow: Int, _ startCol: Int, _ blockRows: Int, _ blockCols: Int) -> M where M.Element == Element {
        let endRow = startRow + blockRows
        let endCol = startCol + blockCols
        
        assert(startRow >= 0 && startCol >= 0 && blockRows > 0 && blockCols > 0)
        assert(endRow <= rows && endCol <= cols)
        
        let outputSize: MatrixSize = [blockRows, blockCols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        var jOut: Int = 0
        for j in startCol..<endCol {
            var iOut: Int = 0
            for i in startRow..<endRow {
                let index = elementIndex(i: iOut, j: jOut, size: outputSize)
                let value = self[i, j]
                (pointer + index).initialize(to: value)
                iOut += 1
            }
            jOut += 1
        }
        return .init(SharedPointer(pointer), outputSize)
    }
    
    // Corner-related operations
    public func topLeftCorner(_ p: Int, _ q: Int) -> MatrixBlock<Element> {
        return block(0, 0, p, q)
    }
    
    public func bottomLeftCorner(_ p: Int, _ q: Int) -> MatrixBlock<Element> {
        return block(rows - p, 0, p, q)
    }
    
    public func topRightCorner(_ p: Int, _ q: Int) -> MatrixBlock<Element> {
        return block(0, cols - q, p, q)
    }
    
    public func bottomRightCorner(_ p: Int, _ q: Int) -> MatrixBlock<Element> {
        return block(rows - p, cols - q, p, q)
    }
    
    public func topRows(_ p: Int) -> MatrixBlock<Element> {
        return block(0, 0, p, cols)
    }
    
    public func bottomRows(_ p: Int) -> MatrixBlock<Element> {
        return block(rows - p, 0, p, cols)
    }
    
    public func bottomRows<M: Matrix>(_ p: Int) -> M where M.Element == Element {
        return block(rows - p, 0, p, cols)
    }
    
    public func leftCols(_ p: Int) -> MatrixBlock<Element> {
        return block(0, 0, rows, p)
    }
    
    public func rightCols(_ p: Int) -> MatrixBlock<Element> {
        return block(0, cols - p, rows, p)
    }
    
    public func middleCols(_ i: Int, _ q: Int) -> MatrixBlock<Element> {
        return block(0, i, rows, q)
    }
    
    public func middleRows(_ i: Int, _ q: Int) -> MatrixBlock<Element> {
        return block(i, 0, q, cols)
    }
}
