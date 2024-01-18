//
//  Vector+largestValueIndex.swift
//  Matrix
//
//  Created by Reza on 1/18/24.
//

import Foundation

extension Vector where Element: Comparable {
    public var largestValueIndex: Int {
        assert(count != 0)
        
        var max = valuesPtr.pointer[0]
        var maxIdx: Int = 0
        
        if count > 1 {
            for i in 1..<count {
                if valuesPtr.pointer[i] > max {
                    max = valuesPtr.pointer[i]
                    maxIdx = i
                }
            }
        }
        
        return maxIdx
    }
}
