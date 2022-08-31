//
//  Puzzle05.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

fileprivate struct Line: Hashable, ExpressibleByStringLiteral, CustomStringConvertible {
    let start, end: Point

    init(stringLiteral value: StringLiteralType) {
        let points = value.components(separatedBy: " -> ")
        let startPointNums = points[0].components(separatedBy: ",")
        let endPointNums = points[1].components(separatedBy: ",")
        start = Point(x: Int(startPointNums[0])!, y: Int(startPointNums[1])!)
        end = Point(x: Int(endPointNums[0])!, y: Int(endPointNums[1])!)
    }

    func allPoints() -> Set<Point> {
        var points = Set<Point>()
        if start.x == end.x {
            for y in stride(from: min(start.y, end.y), to: max(start.y, end.y) + 1, by: 1) {
                points.insert(Point(x: start.x, y: y))
            }
        } else if start.y == end.y {
            for x in stride(from: min(start.x, end.x), to: max(start.x, end.x) + 1, by: 1) {
                points.insert(Point(x: x, y: start.y))
            }
        } else /* line is diagonal */ {
            let xDiff = end.x - start.x
            let yDiff = end.y - start.y
            if abs(xDiff) != abs(yDiff) {
                fatalError("Not a 45 degree diagonal line")
            }
            let isXIncreasing = xDiff > 0
            let isYIncreasing = yDiff > 0
            for i in 0...abs(xDiff) {
                if isXIncreasing, isYIncreasing {
                    points.insert(Point(x: start.x + i, y: start.y + i))
                } else if isXIncreasing, !isYIncreasing {
                    points.insert(Point(x: start.x + i, y: start.y - i))
                } else if !isXIncreasing, isYIncreasing {
                    points.insert(Point(x: start.x - i, y: start.y + i))
                } else {
                    points.insert(Point(x: start.x - i, y: start.y - i))
                }
            }
        }
        return points
    }

    func isDiagonal() -> Bool { !(start.x == end.x || start.y == end.y) }
    var description: String { "\(start) -> \(end)" }
}

struct Puzzle05: Puzzle {
    private let lines = InputFileReader.read("Input05").map(Line.init)

    func part1() {
        var vents = [Point: Int]()
        for line in lines {
            if line.isDiagonal() { continue }
            for vent in line.allPoints() {
                let currentCount = vents[vent, default: 0]
                vents[vent] = (currentCount + 1)
            }
        }
        print(vents.values.filter { $0 > 1 }.count)
    }

    func part2() {
        var vents = [Point: Int]()
        for line in lines {
            for vent in line.allPoints() {
                let currentCount = vents[vent, default: 0]
                vents[vent] = (currentCount + 1)
            }
        }
        print(vents.values.filter { $0 > 1 }.count)
    }
}
