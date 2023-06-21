//
//  MatrixArray+MBoolReduce.swift
//  ClothSimulation
//
//  Created by Reza on 1/26/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public func <<S: MatrixElement & Comparable>(lhs: MatrixArray<S>, rhs: S) -> MBoolReduce<S> {
    return MBoolReduce<S>(pointer: lhs.valuesPtr, count: lhs.size.count, predicate: { $0 < rhs })
}

public func ==<S: MatrixElement & Equatable>(lhs: MatrixArray<S>, rhs: S) -> MBoolReduce<S> {
    return MBoolReduce<S>(pointer: lhs.valuesPtr, count: lhs.size.count, predicate: { $0 == rhs })
}
