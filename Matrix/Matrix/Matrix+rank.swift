//
//  Matrix+rank.swift
//  Fashionator
//
//  Created by Reza on 5/1/23.
//

import Foundation

extension Matrix where Element == Double {
    public func rank() -> Int {
        // Make a copy of self
        let A = Self.init(self, self.rows, self.cols)
        
        let EPS: Element = 1.0e-14
        let n = A.rows
        let m = A.cols
        
        var rank: Int = 0
        var row_selected: [Bool] = .init(repeating: false, count: n)
        
        for i in 0..<m {
            var j: Int?
            
            for t in 0..<n {
                if (!row_selected[t] && abs(A[t, i]) > EPS) {
                    j = t
                    break
                }
            }
            
            if let j = j {
                rank += 1
                row_selected[j] = true
                for p in (i + 1)..<m {
                    A.ptrRef(j, p).pointee /= A[j, i]
                }
                for k in 0..<n {
                    if (k != j && abs(A[k, i]) > EPS) {
                        for p in (i + 1)..<m {
                            A.ptrRef(k, p).pointee -= (A[j, p] * A[k, i])
                            print(A)
                        }
                    }
                }
            }
        }
        return rank
    }
}
