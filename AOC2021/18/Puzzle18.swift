//
//  Puzzle18.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

indirect enum Number: CustomStringConvertible {
    case pair(Number, Number)
    case value(Int)

    func traverse(_ process: (Int, Int) -> Void, depth: Int = 0) {
        switch self {
        case .pair(let l, let r):
            l.traverse(process, depth: depth + 1)
            r.traverse(process, depth: depth + 1)
        case .value(let num):
            process(num, depth)
        }
    }

    var description: String {
        switch self {
        case .pair(let l, let r):
            return "[\(l),\(r)]"
        case .value(let num):
            return "\(num)"
        }
    }
}

struct Puzzle18: Puzzle {
    private let nums: [Number]

    init() {
        nums = InputFileReader.read("Input18-test").map(Puzzle18.parseNumber)
    }

    func part1() {
        var nums = self.nums
        for i in nums.indices {
            var num = nums[i]
            explode(num)
        }
    }

    func part2() {

    }

    func explode(_ num: Number, depth: Int = 0) {
        switch num {
        case .pair(let l, let r):
            if depth == 4 {
                print("will explode [\(l), \(r)]")
            } else {
                explode(l, depth: depth+1)
                explode(r, depth: depth+1)
            }
        case .value(let num):
            print(num)
        }
    }

    static func parseNumber(_ string: String) -> Number {
        var numArray = [Number]()
        for char in string {
            if let digit = char.wholeNumberValue {
                numArray.append(.value(digit))
            } else if char == "]" {
                let rightNum = numArray.popLast()!
                let leftNum = numArray.popLast()!
                numArray.append(.pair(leftNum, rightNum))
            }
        }
        return numArray.first!
    }
}
