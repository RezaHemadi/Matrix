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
        self.conservativeResize(Self.Rows == 1 ? 1 : n,
                                Self.Cols == 1 ? 1 : n)
    }
}
