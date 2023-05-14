//
//  Vector+dot.swift
//  ClothSimulation
//
//  Created by Reza on 1/21/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Vector where Element: Numeric {
    public func dot<V: Vector>(_ other: V) -> Element where V.Element == Element {
        assert(count == other.count )
        
        var total: Element = .zero
        for i in 0..<count {
            let value: Element = self[i] * other[i]
            total += value
        }
        
        return total
    }
}
