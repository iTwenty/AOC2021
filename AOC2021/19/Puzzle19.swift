//
//  Puzzle19.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

// p is positive, n is negative.
fileprivate enum Orientation { case px, py, pz, nx, ny, nz }

fileprivate struct Point3D: Hashable, CustomStringConvertible {
    let x, y, z: Int
    var description: String { "\(x), \(y), \(z)" }
}

struct Puzzle19: Puzzle {
    private let scanner: [[Point3D]]

    init() {
        var scanner = [[Point3D]]()
        var currentScanner = [Point3D]()
        InputFileReader.read("Input19", omitEmptySubsequences: false).forEach { line in
            if line.isEmpty {
                scanner.append(currentScanner)
                currentScanner = []
            } else if !line.contains("scanner") {
                let coords = line.components(separatedBy: ",")
                let x = Int(coords[0])!
                let y = Int(coords[1])!
                let z = Int(coords[2])!
                currentScanner.append(Point3D(x: x, y: y, z: z))
            }
        }
        self.scanner = scanner
    }

    func part1() {
        allPossibleOrientations(Point3D(x: 4, y: 6, z: -5)).forEach {
            print($0)
        }
    }

    func part2() {

    }

    private func allPossibleOrientations(_ point: Point3D) -> [Point3D] {
        return [
            // Four rotations along Z axis with Z pointed right way
            point,
            Point3D(x: -point.y, y: point.x, z: point.z),
            Point3D(x: -point.x, y: -point.y, z: point.z),
            Point3D(x: point.y, y: -point.x, z: point.z),

            // Four rotations along Z axis with Z pointed wrong way
            Point3D(x: point.x, y: point.y, z: -point.z),
            Point3D(x: -point.y, y: point.x, z: -point.z),
            Point3D(x: -point.x, y: -point.y, z: -point.z),
            Point3D(x: point.y, y: -point.x, z: -point.z),

            Point3D(x: point.x, y: -point.z, z: point.y),
            Point3D(x: point.z, y: point.x, z: point.y),
            Point3D(x: -point.x, y: point.z, z: point.y),
            Point3D(x: -point.z, y: -point.x, z: point.y),

            Point3D(x: point.x, y: -point.z, z: -point.y),
            Point3D(x: point.z, y: point.x, z: -point.y),
            Point3D(x: -point.x, y: point.z, z: -point.y),
            Point3D(x: -point.z, y: -point.x, z: -point.y),

            Point3D(x: point.z, y: point.y, z: point.x),
            Point3D(x: -point.y, y: point.z, z: point.x),
            Point3D(x: -point.z, y: -point.y, z: point.x),
            Point3D(x: point.y, y: -point.z, z: point.x),

            Point3D(x: point.z, y: point.y, z: -point.x),
            Point3D(x: -point.y, y: point.z, z: -point.x),
            Point3D(x: -point.z, y: -point.y, z: -point.x),
            Point3D(x: point.y, y: -point.z, z: -point.x),
        ]
    }
}
