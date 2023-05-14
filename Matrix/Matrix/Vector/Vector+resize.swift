//
//  Vector+resize.swift
//  ClothSimulation
//
//  Created by Reza on 1/14/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Vector {
    public mutating func resize(_ size: Int) {
        if Self.Rows == 0 {
            // column vector
            self.resize(size, 1)
        } else {
            // Row vector
            self.resize(1, size)
        }
    }
}
