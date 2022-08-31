//
//  Puzzle09.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle09: Puzzle {
    private let heightmap: [[Int]]
    private let maxRow, maxCol, maxHeight: Int

    init() {
        heightmap = InputFileReader.read("Input09").map { line in
            line.compactMap { $0.wholeNumberValue }
        }
        maxRow = heightmap.count
        maxCol = heightmap[0].count
        maxHeight = 9
    }

    func part1() {
        let lowPoints = lowPoints()
        let lowPointHeights = lowPoints.map { heightmap[$0.x][$0.y] }
        // Part 1
        print(lowPointHeights.reduce(lowPointHeights.count, +))
        let basins = lowPoints.map(basinPoints(lowPoint:))
        // Part 2
        print(basins.map(\.count).sorted(by: >)[0..<3].reduce(1, *))
    }

    func part2() { print("Nothing to do!") }

    private func lowPoints() -> [Point] {
        var lowPoints = [Point]()
        for x in (0..<heightmap.endIndex) {
            for (y, height) in heightmap[x].enumerated() {
                let neighbours = neighbouringPoints(Point(x: x, y: y))
                if neighbours.allSatisfy({ heightmap[$0.x][$0.y] > height }) {
                    lowPoints.append(Point(x: x, y: y))
                }
            }
        }
        return lowPoints
    }

    private func neighbouringPoints(_ point: Point) -> [Point] {
        let row = point.x
        let col = point.y
        var neighbours = [Point]()
        if row-1 > -1 {
            neighbours.append(Point(x: row-1, y: col))
        }
        if col+1 < maxCol {
            neighbours.append(Point(x: row, y: col+1))
        }
        if row+1 < maxRow {
            neighbours.append(Point(x: row+1, y: col))
        }
        if col-1 > -1 {
            neighbours.append(Point(x: row, y: col-1))
        }
        return neighbours
    }

    private func basinPoints(lowPoint: Point) -> Set<Point> {
        var visited = Set<Point>()
        var queue = [lowPoint]
        while !queue.isEmpty {
            let current = queue.removeFirst()
            visited.insert(current)
            let neighbours = neighbouringPoints(current)
            for neighbour in neighbours {
                if !visited.contains(neighbour), heightmap[neighbour.x][neighbour.y] != maxHeight {
                    queue.append(neighbour)
                }
            }
        }
        return visited
    }
}
