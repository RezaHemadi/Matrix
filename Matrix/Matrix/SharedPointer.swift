//
//  SharedPointer.swift
//  ClothSimulation
//
//  Created by Reza on 1/13/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

public class SharedPointer<T> {
    public var pointer: UnsafeMutablePointer<T>
    
    public init(_ pointer: UnsafeMutablePointer<T>) {
        self.pointer = pointer
    }
    
    deinit {
        pointer.deallocate()
    }
}
