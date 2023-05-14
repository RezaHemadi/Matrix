//
//  Vector+conservativeResize.swift
//  ClothSimulation
//
//  Created by Reza on 1/26/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Vector {
    public mutating func conservativeResize(_ n: Int) {
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: n)
        pointer.initialize(from: valuesPtr.pointer, count: n > size.count ? size.count : n)
        
        if n > size.count {
            for i in size.count..<n {
                (pointer + i).initialize(to: .init())
            }
        }
        
        valuesPtr = .init(pointer)
        size = [Self.Rows == 1 ? 1 : n,
                Self.Cols == 1 ? 1 : n]
    }
}
