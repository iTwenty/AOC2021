//
//  Point.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 31/08/22.
//

import Foundation

struct Point: Hashable, CustomStringConvertible, Comparable {
    let x, y: Int
    var description: String { "(\(x), \(y))" }
    static func < (lhs: Point, rhs: Point) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        } else {
            return lhs.y < rhs.y
        }
    }
}
