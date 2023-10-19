//
//  Vector+Initializers.swift
//  ClothSimulation
//
//  Created by Reza on 1/15/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Vector {
    public init() {
        let size: MatrixSize = [Self.Rows, Self.Cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(repeating: .init(), count: size.count)
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init(arrayLiteral elements: Element...) {
        self.init(elements, Self.Rows == 0 ? [elements.count, 1] : Self.Rows == 1 ? [1, elements.count] : [elements.count, 1])
    }
    
    public init(_ elements: [Element]) {
        //self.init(elements, Self.Rows == 0 ? [elements.count, 1] : [1, elements.count])
        self.init(elements, Self.Rows == 0 ? [elements.count, 1] : Self.Rows == 1 ? [1, elements.count] : [elements.count, 1])
    }
    
    public init(_ count: Int) {
        let size: MatrixSize = [Self.Rows == 0 ? count : Self.Rows, Self.Cols == 0 ? count : Self.Cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(repeating: .init(), count: size.count)
        self.init(SharedPointer(pointer), size)
    }
    
    public init<V: Vector>(_ vectors: V...) where V.Element == Element {
        let count: Int = vectors.map({ $0.size.count }).reduce(0, +)
        let size: MatrixSize = [Self.Rows == 0 ? count : Self.Rows, Self.Cols == 0 ? count : Self.Cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: count)
        
        var i = 0
        for m in 0..<vectors.count {
            let vec = vectors[m]
            for n in 0..<vec.size.count {
                (pointer + i).initialize(to: vec[n])
                i += 1
            }
        }
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init(_ columns: MatrixColumn<Element>...) {
        let count: Int = columns.map({ $0.rows }).reduce(0, +)
        let size: MatrixSize = [Self.Rows == 0 ? count : Self.Rows, Self.Cols == 0 ? count : Self.Cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: count)
        
        var i = 0
        for m in 0..<columns.count {
            let column = columns[m]
            for n in 0..<column.rows {
                (pointer + i).initialize(to: column[n])
                i += 1
            }
        }
        
        self.init(SharedPointer(pointer), size)
    }
    
    public init(_ rows: MatrixRow<Element>...) {
        let count: Int = rows.map({ $0.columns }).reduce(0, +)
        let size: MatrixSize = [Self.Rows == 0 ? count : Self.Rows, Self.Cols == 0 ? count : Self.Cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: count)
        
        var i = 0
        for m in 0..<rows.count {
            let row = rows[m]
            for n in 0..<row.columns {
                (pointer + i).initialize(to: row[n])
                i += 1
            }
        }
        
        self.init(SharedPointer(pointer), size)
    }
    
    public static func Zero(_ size: Int) -> Self {
        self.init(size)
    }
    
    public static func Ones(_ count: Int = Self.Rows == 1 ? Self.Cols : Self.Rows) -> Self where Element: ExpressibleByIntegerLiteral {
        let size: MatrixSize = [Self.Rows == 0 ? count : Self.Rows, Self.Cols == 0 ? count : Self.Cols]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        pointer.initialize(repeating: 1, count: size.count)
        
        return .init(SharedPointer(pointer), size)
    }
    
    public static func LineSpaced(low: Element, high: Element, count: Int = Self.Rows == 1 ? Self.Cols : Self.Rows) -> Self where Self.Element: FloatingPoint {
        assert(low <= high)
        assert(count > 0)
        let size: MatrixSize = [Self.Rows == 0 ? count : Self.Rows, Self.Cols == 0 ? count : Self.Cols]
        
        // if count is 1 return a vector containing 'high'
        if count == 1 {
            return .init([high], size)
        }
        
        // If count is 2 return [low, high]
        if count == 2 {
            return .init([low, high], size)
        }
        
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: count)
        pointer.initialize(to: low)
        
        let d = (high - low) / Element(count - 1)
        for i in 1..<count {
            let value = low + (Element(i) * d)
            (pointer + i).initialize(to: value)
        }
        
        return .init(SharedPointer(pointer), size)
    }
    
    public static func LineSpaced(low: Element, high: Element, count: Int = Self.Rows == 1 ? Self.Cols : Self.Rows) -> Self where Self.Element == Int {
        assert(low <= high)
        assert(count > 0)
        
        let size: MatrixSize = [Self.Rows == 0 ? count : Self.Rows, Self.Cols == 0 ? count : Self.Cols]
        
        // if count is 1 return vector containing 'high'
        if count == 1 {
            return .init([high], size)
        }
        
        // if count is 2 return [low, high]
        if count == 2 {
            return .init([low, high], size)
        }
        
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: count)
        if (high - low).isMultiple(of: count - 1) {
            pointer.initialize(to: low)
            let d = (high - low) / (count - 1)
            for i in 1..<count {
                (pointer + i).initialize(to: low + i * d)
            }
            
            return .init(SharedPointer(pointer), size)
        } else if (count % (high - low + 1) == 0) {
            let rep = count / (high - low + 1)
            var n: Int = 0
            for i in low...high {
                for _ in 0..<rep {
                    (pointer + n).pointee = i
                    n += 1
                }
            }
            
            return .init(SharedPointer(pointer), size)
        } else {
            var high = high
            repeat {
                high = high - 1
            } while (count % (high - low + 1) != 0 && high >= low)
            
            if high >= low {
                let rep = count / (high - low + 1)
                var n: Int = 0
                for i in low...high {
                    for _ in 0..<rep {
                        (pointer + n).pointee = i
                        n += 1
                    }
                }
                
                return .init(SharedPointer(pointer), size)
            } else {
                fatalError()
            }
        }
    }
}
