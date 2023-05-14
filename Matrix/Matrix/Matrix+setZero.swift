//
//  Matrix+setZero.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public mutating func setZero() {
        valuesPtr.pointer.initialize(repeating: .init(), count: size.count)
    }
}
