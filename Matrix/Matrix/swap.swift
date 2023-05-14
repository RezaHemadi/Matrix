//
//  swap.swift
//  ClothSimulation
//
//  Created by Reza on 1/19/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public func swap<M1: Matrix, M2: Matrix>(M1: M1, M2: M2, M1Index: [Int], M2Index: [Int]) where M1.Element == M2.Element {
    assert(M1Index.count == 2)
    assert(M2Index.count == 2)
    
    let m1ElementIndex = elementIndex(i: M1Index[0], j: M1Index[1], size: M1.size)
    let temp = M1.valuesPtr.pointer[m1ElementIndex]
    
    let m2ElementIndex = elementIndex(i: M2Index[0], j: M2Index[1], size: M2.size)
    M1.valuesPtr.pointer[m1ElementIndex] = M2.valuesPtr.pointer[m2ElementIndex]
    
    M2.valuesPtr.pointer[m2ElementIndex] = temp
}

public func swap<T>(_ a: UnsafeMutablePointer<T>, _ b: UnsafeMutablePointer<T>) {
    let tmp: T = a.pointee
    a.pointee = b.pointee
    b.pointee = tmp
}
