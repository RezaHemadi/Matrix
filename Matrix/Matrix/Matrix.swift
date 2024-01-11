//
//  Matrix.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public protocol Matrix: CustomStringConvertible, Equatable {
    // MARK: - Types
    associatedtype Element: MatrixElement
    associatedtype TransposeType: Matrix
    associatedtype ColType
    associatedtype RowType
    
    // MARK: - Properties
    static var Rows: Int { get }
    static var Cols: Int { get }
    
    var size: MatrixSize { get set }
    var rows: Int { get }
    var cols: Int { get }
    var valuesPtr: SharedPointer<Element> { get set }
    var values: [Element] { get }
    var capacity: Int { get set }
    
    // MARK: - Subscript
    subscript(_: Int, _: Int) -> Element { get set }
    subscript(_: Int) -> Element { get set }
    
    // MARK: - Initialization
    init()
    init(_:SharedPointer<Element>, _: MatrixSize)
    init(_: [Element], _: MatrixSize)
    init(_: Int, _: Int)
    init(_: MatrixBlock<Element>)
    static func Zero(_: Int, _: Int) -> Self
    static func Constant(_: Int, _: Int, _: Element) -> Self
    
    // MARK: - Methods
    func transpose() -> TransposeType
    mutating func resize(_: Int, _: Int)
    mutating func conservativeResize(_: Int, _: Int)
    mutating func setZero()
    func col(_: Int) -> MatrixColumn<Element>
    func row(_: Int) -> MatrixRow<Element>
    func block(_: Int, _: Int, _: Int, _: Int) -> MatrixBlock<Element>
    func array() -> MatrixArray<Element>
    func ptrRef(_: Int, _: Int) -> UnsafeMutablePointer<Element>
    mutating func reserveCapacity(_: Int)
    mutating func removeRowsAt(_:Range<Int>)
}

extension Matrix {
    public var rows: Int { size.rows }
    public var cols: Int { size.cols }
    
    public var values: [Element] {
        var output = [Element]()
        for i in 0..<size.count {
            output.append(valuesPtr.pointer[i])
        }
        return output
    }
}
