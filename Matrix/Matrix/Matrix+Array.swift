//
//  Matrix+Array.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Matrix {
    public func array() -> MatrixArray<Element> {
        return .init(valuesPtr: valuesPtr, size: size)
    }
}
