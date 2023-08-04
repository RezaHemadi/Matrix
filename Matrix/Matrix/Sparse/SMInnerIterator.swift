//
//  SMInnerIterator.swift
//  ClothSimulation
//
//  Created by Reza on 1/27/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public struct SMInnerIterator<S: MatrixElement>: Sequence {
    // MARK: - Properties
    
    /// number of non zeros in this outer index
    private let count: Int
    
    /// index of the current outer iteration
    public let outerIndex: Int
    
    /// column numbers
    public let inners: [Int]
    
    /// non zero values in current outer iteration
    public let values: [S]
    
    // MARK: - Initialization
    public init(_ count: Int, _ outerIndex: Int, _ inners: [Int], _ values: [S]) {
        assert(inners.count == values.count)
        
        self.count = count
        self.outerIndex = outerIndex
        self.inners = inners
        self.values = values
    }
    
    // MARK: - Methods
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }
}

extension SMInnerIterator {
    public struct Iterator: IteratorProtocol {
        public let iterator: SMInnerIterator
        /// keep track of curIdx inside inners and values arrays
        public var curIdx: Int = 0
        
        public init(_ iterator: SMInnerIterator) {
            self.iterator = iterator
        }
        
        public mutating func next() -> MatrixEntry<S>? {
            guard curIdx < iterator.count else { return nil }
            defer { curIdx += 1}
            
            return .init(row: iterator.outerIndex,
                         col: iterator.inners[curIdx],
                         value: iterator.values[curIdx])
        }
    }
}

public struct MatrixEntry<S: MatrixElement> {
    public let row: Int
    public let col: Int
    public let value: S
    /// inner index, here it is equal to col
    public var index: Int {
        return col
    }
}
