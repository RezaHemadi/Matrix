//
//  elementIndex.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

/// returns the index of element in values for column major matrix with
///  specified row and column index and size
public func elementIndex(i: Int, j: Int, size: MatrixSize) -> Int {
    // when cols fill first
    //return (j * size.rows + i)
    
    // when rows fill first
    return (size.cols * i + j)
}
