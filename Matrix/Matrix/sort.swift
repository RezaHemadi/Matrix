//
//  sort.swift
//  ClothSimulation
//
//  Created by Reza on 1/20/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public func sort<M: Matrix>(matrix: inout M, areInIncreasingOrder: (M.Element, M.Element) -> Bool) where M.Element: Comparable {
    var valuesArray = matrix.values
    valuesArray.sort(by: areInIncreasingOrder)
    for i in 0..<valuesArray.count {
        matrix.valuesPtr.pointer[i] = valuesArray[i]
    }
}
