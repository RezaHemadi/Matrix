//
//  Matrix+Initializers.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public init() {
        let size: MatrixSize = [Self.Rows, Self.Cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(repeating: .init(), count: size.count)
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init<M: Matrix>(_ m: M, _ size: MatrixSize) where M.Element == Element {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(from: m.valuesPtr.pointer, count: size.count)
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init<M: Matrix>(_ m: M, _ rows: Int, _ cols: Int) where M.Element == Element {
        let size: MatrixSize = [rows, cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(from: m.valuesPtr.pointer, count: size.count)
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init(_ values: [Element], _ size: MatrixSize) {
        assert(values.count == size.count)
        
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(from: values, count: size.count)
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init(_ values: [Element]) {
        assert(Self.Rows != 0 && Self.Cols != 0)
        
        let size: MatrixSize = [Self.Rows, Self.Cols]
        
        self.init(values, size)
    }
    
    public init(_ rows: Int, _ cols: Int) {
        let size: MatrixSize = [rows, cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(repeating: .init(), count: size.count)
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init(_ block: MatrixBlock<Element>) {
        let size = block.size
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(from: block.values.map({$0.pointee}), count: size.count)
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init<V: Vector>(rows: [V]) where V.Element == Element {
        typealias S = V.Element
        assert(!rows.isEmpty)
        let colCount = rows[0].size.count
        assert(rows.allSatisfy({ $0.size.count == colCount }))
        let rowCount = rows.count
        
        let size: MatrixSize = [rowCount, colCount]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
        
        for j in 0..<colCount {
            for i in 0..<rowCount {
                let index = elementIndex(i: i, j: j, size: size)
                let value = rows[i][j]
                (pointer + index).initialize(to: value)
            }
        }
        
        self.init(SharedPointer<S>(pointer), size)
    }
    
    public init(rows: [MatrixRow<Element>]) {
        assert(!rows.isEmpty)
        let colCount = rows[0].count
        assert(rows.allSatisfy({ $0.count == colCount }))
        let rowCount = rows.count
        
        let size: MatrixSize = [rowCount, colCount]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        for j in 0..<colCount {
            for i in 0..<rowCount {
                let index = elementIndex(i: i, j: j, size: size)
                let value = rows[i].values[j].pointee
                (pointer + index).initialize(to: value)
            }
        }
        
        self.init(SharedPointer<Element>(pointer), size)
    }
    
    public init<V: Vector>(columns: [V]) where V.Element == Element {
        typealias S = V.Element
        assert(!columns.isEmpty)
        let rowCount = columns[0].size.count
        assert(columns.allSatisfy({ $0.size.count == rowCount }))
        let colCount = columns.count
        
        let size: MatrixSize = [rowCount, colCount]
        let pointer: UnsafeMutablePointer<S> = .allocate(capacity: size.count)
        
        for j in 0..<colCount {
            for i in 0..<rowCount {
                let index = elementIndex(i: i, j: j, size: size)
                let value = columns[j][i]
                (pointer + index).initialize(to: value)
            }
        }
        
        self.init(SharedPointer<S>(pointer), size)
    }
    
    public init(columns: [MatrixColumn<Element>]) {
        assert(!columns.isEmpty)
        let rowCount = columns[0].count
        assert(columns.allSatisfy({ $0.count == rowCount }))
        let colCount = columns.count
        
        let size: MatrixSize = [rowCount, colCount]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        
        for j in 0..<colCount {
            for i in 0..<rowCount {
                let index = elementIndex(i: i, j: j, size: size)
                let value = columns[j].values[i].pointee
                (pointer + index).initialize(to: value)
            }
        }
        
        self.init(SharedPointer<Element>(pointer), size)
    }
    
    public static func Zero(_ rows: Int, _ cols: Int) -> Self {
        return .init(rows, cols)
    }
    
    public static func Ones(_ rows: Int = Self.Rows, _ cols: Int = Self.Cols) -> Self where Element: ExpressibleByIntegerLiteral {
        let size: MatrixSize = [rows, cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(repeating: 1, count: size.count)
        
        return .init(SharedPointer(pointer), size)
    }
    
    public static func Constant(_ rows: Int, _ cols: Int, _ value: Element) -> Self {
        let size: MatrixSize = [rows, cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(repeating: value, count: size.count)
        
        return .init(SharedPointer(pointer), size)
    }
    
    public static func Identity() -> Self where Element: ExpressibleByIntegerLiteral {
        assert(Self.Rows != 0 && Self.Cols != 0)
        assert(Self.Rows == Self.Cols)
        
        let size: MatrixSize = .init(Self.Rows, Self.Cols)
        let ptr: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        ptr.initialize(repeating: 0, count: size.count)
        
        for i in 0..<size.rows {
            let index = elementIndex(i: i, j: i, size: size)
            ptr[index] = 1
        }
        
        return .init(SharedPointer(ptr), size)
    }
    
    /// Initialize dense matrix from a sparse matrix
    public init(_ spMat: SparseMatrix<Element>) where Element: Numeric {
        guard let size = spMat.size else { fatalError("spMat not initialized") }
        
        let ptr: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        ptr.initialize(repeating: .zero, count: size.count)
        
        for k in 0..<spMat.outerSize {
            for it in spMat.innerIterator(k) {
                let index = elementIndex(i: it.row, j: it.col, size: size)
                ptr[index] = it.value
            }
        }
        
        self.init(SharedPointer(ptr), size)
    }
}
