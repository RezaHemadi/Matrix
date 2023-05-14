//
//  MatrixElement.swift
//  ClothSimulation
//
//  Created by Reza on 1/11/23.
//  Copyright © 2023 DynamicStacks LTD. All rights reserved.
//

import Foundation

extension Double: MatrixElement {}
extension Int: MatrixElement {}
extension Float: MatrixElement {}
//extension Float80: MatrixElement {}
extension Bool: MatrixElement {}
extension UInt: MatrixElement {}
extension UInt32: MatrixElement {}

public protocol MatrixElement: CustomStringConvertible {
    init()
}
