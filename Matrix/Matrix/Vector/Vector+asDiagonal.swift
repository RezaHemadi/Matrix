//
//  Vector+asDiagonal.swift
//  ClothSimulation
//
//  Created by Reza on 1/16/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Vector {
    public func asDiagonal() -> Mat<Element> {
        let size: MatrixSize = [self.size.count, self.size.count]
        let pointer: UnsafeMutablePointer<Element> = .allocate(capacity: size.count)
        var t = 0
        for i in 0..<size.rows {
            for j in 0..<size.cols {
                if (i == j) {
                    (pointer + t).initialize(to: self[i])
                } else {
                    (pointer + t).initialize(to: .init())
                }
                t += 1
            }
        }
        
        return Mat<Element>(SharedPointer(pointer), size)
    }
}
