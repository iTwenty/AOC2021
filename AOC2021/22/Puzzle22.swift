//
//  Puzzle22.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

fileprivate struct Cuboid {
    let xs, ys, zs: ClosedRange<Int>
    var count: Int {
        xs.count * ys.count * zs.count
    }
}

fileprivate struct Step {
    let on: Bool
    let cuboid: Cuboid
}

struct Puzzle22: Puzzle {
    private let steps: [Step]

    init() {
        steps = InputFileReader.read("Input22").map { line in

            let split = line
                .replacingOccurrences(of: " ", with: ",")
                .components(separatedBy: ",")
            let on = split[0] == "on"
            let xs = Puzzle22.parseRange(split[1])
            let ys = Puzzle22.parseRange(split[2])
            let zs = Puzzle22.parseRange(split[3])
            return Step(on: on, cuboid: Cuboid(xs: xs, ys: ys, zs: zs))
        }
    }

    func part1() {
        print(reboot(steps: steps[0..<20]))
    }

    func part2() {
        print(reboot(steps: steps))
    }

    private func reboot<P: Collection>(steps: P) -> Int where P.Element == Step {
        // The on bool of Step is used as +1/-1 in this array
        // Don't confuse this with Step being used as input instruction line
        // Reusing the same struct for a totally different purpose here.
        var ons = [steps.first!]
        for step in steps.dropFirst() {
            var toAdd = [Step]()
            if step.on {
                toAdd.append(step)
            }
            for on in ons {
                let intersection = intersection(lhs: on.cuboid, rhs: step.cuboid)
                if let intersection = intersection {
                    toAdd.append(Step(on: !on.on, cuboid: intersection))
                }
            }
            ons.append(contentsOf: toAdd)
        }

        let onCount = ons.reduce(0) { acc, on in
            let tmp = (on.on ? 1 : -1) * on.cuboid.count
            return acc + tmp
        }
        return onCount
    }

    private func intersection(lhs: Cuboid, rhs: Cuboid) -> Cuboid? {
        let xMin = max(lhs.xs.lowerBound, rhs.xs.lowerBound)
        let xMax = min(lhs.xs.upperBound, rhs.xs.upperBound)
        let yMin = max(lhs.ys.lowerBound, rhs.ys.lowerBound)
        let yMax = min(lhs.ys.upperBound, rhs.ys.upperBound)
        let zMin = max(lhs.zs.lowerBound, rhs.zs.lowerBound)
        let zMax = min(lhs.zs.upperBound, rhs.zs.upperBound)
        if xMin <= xMax, yMin <= yMax, zMin <= zMax {
            return Cuboid(xs: xMin...xMax, ys: yMin...yMax, zs: zMin...zMax)
        }
        return nil
    }

    private static func parseRange(_ str: String) -> ClosedRange<Int> {
        let nums = str.dropFirst(2).components(separatedBy: "..")
        let start = Int(nums[0])!
        let end = Int(nums[1])!
        return start...end
    }
}
