//
//  sortrows.swift
//  ClothSimulation
//
//  Created by Reza on 1/20/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public func sortrows<M1: Matrix, M2: Matrix>(_ X: M1, _ ascending: Bool, _ Y: inout M1, _ IX: inout M2) where M2.Element == Int, M1.Element: Comparable {
    
    let num_rows = X.rows
    let num_cols = X.cols
    Y.resize(num_rows, num_cols)
    IX.resize(num_rows, 1)
    
    for i in 0..<num_rows {
        IX[i] = i
    }
    if ascending {
        let index_less_than: (Int, Int) -> Bool = { i, j in
            for c in 0..<num_cols {
                if (X[i, c] < X[j, c]) { return true }
                else if (X[j, c] < X[i, c]) { return false }
            }
            return false
        }
        
        sort(matrix: &IX, areInIncreasingOrder: index_less_than)
    } else {
        let index_greater_than: (Int, Int) -> Bool = { i, j in
            for c in 0..<num_cols {
                if (X[i, c] > X[j, c]) { return true }
                else if (X[j, c] > X[i, c]) { return false }
            }
            return false
        }
        sort(matrix: &IX, areInIncreasingOrder: index_greater_than)
    }
    
    for j in 0..<num_cols {
        for i in 0..<num_rows {
            Y[i, j] = X[IX[i], j]
        }
    }
}
