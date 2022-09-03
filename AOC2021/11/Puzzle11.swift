//
//  Puzzle11.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle11: Puzzle {
    private let initialState = InputFileReader.read("Input11").map { $0.map(\.wholeNumberValue!) }
    private let range: Range<Int>

    init() {
        range = (initialState.startIndex..<initialState.endIndex)
    }

    func part1() {
        var current = initialState
        var totalFlashes = 0
        for i in (1...) {
            let (new, flashes) = newState(from: current)
            current = new
            totalFlashes += flashes
            if i == 100 {
                print(totalFlashes) // Part 1
            }
            if flashes == range.count * range.count {
                print(i) // Part 2
                break
            }
        }
    }

    func part2() { }

    // Returns (new state, # of flashes)
    private func newState(from state: [[Int]]) -> ([[Int]], Int) {
        var new = state
        var toFlash = [Point]()
        var flashed = Set<Point>()

        // First, increase each level by 1
        for (x, row) in new.enumerated() {
            for (y, level) in row.enumerated() {
                new[x][y] = level + 1
            }
        }

        // Second, for each level above 9, flash it.
        // Simple BFS to propagate flashes.
        for (x, row) in new.enumerated() {
            for y in row.indices {
                let point = Point(x: x, y: y)
                if new[x][y] > 9 {
                    toFlash.append(point)
                    while !toFlash.isEmpty {
                        let current = toFlash.removeFirst()
                        if flashed.contains(current) { continue }
                        flashed.insert(current)
                        for neighbourPoint in neighouringPoints(current) {
                            let value = new[neighbourPoint.x][neighbourPoint.y]
                            new[neighbourPoint.x][neighbourPoint.y] = value + 1
                            if new[neighbourPoint.x][neighbourPoint.y] > 9 {
                                toFlash.append(neighbourPoint)
                            }
                        }
                    }
                }
            }
        }

        // Third, reset every point that flashed to 0
        for point in flashed {
            new[point.x][point.y] = 0
        }
        return (new, flashed.count)
    }

    private func neighouringPoints(_ point: Point) -> [Point] {
        let xyDiffs = [(-1,-1), (-1,0), (-1,+1), (0,-1), (0,+1), (+1,-1), (+1,0), (+1,+1)]
        let neighourPoints = xyDiffs.compactMap { (x, y) -> Point? in
            let neighbourX = point.x + x
            let neighbourY = point.y + y
            if range.contains(neighbourX), range.contains(neighbourY) {
                return Point(x: neighbourX, y: neighbourY)
            } else {
                return nil
            }
        }
        return neighourPoints
    }
}
