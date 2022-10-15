//
//  Puzzle17.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

fileprivate class Probe: CustomStringConvertible {
    var velocity: Point
    var position: Point

    init(velocity: Point) {
        self.position = Point(x: 0, y: 0)
        self.velocity = velocity
    }

    func step() {
        position = Point(x: position.x + velocity.x, y: position.y + velocity.y)
        let newVelocityX = velocity.x == 0 ? 0 : (velocity.x >= 1 ? velocity.x - 1 : velocity.x + 1)
        let newVelocityY = velocity.y - 1
        velocity = Point(x: newVelocityX, y: newVelocityY)
    }

    var description: String { position.description }
}

fileprivate struct Target {
    let xRange: ClosedRange<Int>
    let yRange: ClosedRange<Int>
    static let test = Target(xRange: 20...30, yRange: (-10)...(-5))
    static let prod = Target(xRange: 248...285, yRange: (-85)...(-56))

    func contains(_ probe: Probe) -> Bool {
        xRange.contains(probe.position.x) && yRange.contains(probe.position.y)
    }

    func overshot(_ probe: Probe) -> Bool {
        probe.position.x > xRange.last! || probe.position.y < yRange.first!
    }

    var initialVelocityXRange: ClosedRange<Int> {
        -abs(xRange.last!)...abs(xRange.last!)
    }

    var initialVelocityYRange: ClosedRange<Int> {
        -abs(yRange.first!)...abs(yRange.first!)
    }
}


struct Puzzle17: Puzzle {
    private let target = Target.prod

    func part1() {
        var maxYGlobal = -1
        var count = 0
        for x in target.initialVelocityXRange {
            for y in target.initialVelocityYRange {
                if let y = maxY(forInitialVelocity: Point(x: x, y: y)) {
                    maxYGlobal = max(maxYGlobal, y)
                    count += 1
                }
            }
        }
        print(maxYGlobal)
        print(count)
    }

    func part2() { /* Done in part 1 */ }

    private func maxY(forInitialVelocity velocity: Point) -> Int? {
        let probe = Probe(velocity: velocity)
        var currentMaxY = probe.position.y

        while true {
            probe.step()
            if probe.position.y > currentMaxY {
                currentMaxY = probe.position.y
            }
            if target.contains(probe) {
                return currentMaxY
            } else if target.overshot(probe) {
                return nil
            }
        }
    }
}
