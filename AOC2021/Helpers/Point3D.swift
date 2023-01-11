//
//  Point3D.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 10/01/23.
//

import Foundation

struct Point3D: Hashable, CustomStringConvertible {
    let x, y, z: Int
    var description: String { "\(x), \(y), \(z)" }
}
