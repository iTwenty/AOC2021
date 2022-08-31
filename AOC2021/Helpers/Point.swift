//
//  Point.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 31/08/22.
//

import Foundation

struct Point: Hashable, CustomStringConvertible {
    let x, y: Int
    var description: String { "(\(x), \(y))" }
}
