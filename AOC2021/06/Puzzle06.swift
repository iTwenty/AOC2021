//
//  Puzzle06.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle06: Puzzle {
    // private let initial = [3,4,3,1,2]
    private let initial = InputFileReader.read("Input06")[0].components(separatedBy: ",").compactMap(Int.init)

    func part1() {
        print(fishCount(days: 80))
    }

    func part2() {
        print(fishCount(days: 256))
    }

    private func fishCount(days: Int) -> Int {
        var allStates = Array(repeating: 0, count: 9)
        for fish in initial {
            allStates[fish] += 1
        }
        for _ in 1...days {
            let zeroCount = allStates[0]
            for i in 0..<(allStates.endIndex-1) {
                if i == 6 {
                    allStates[i] = zeroCount
                    allStates[i] += allStates[i+1]
                } else {
                    allStates[i] = allStates[i+1]
                }
            }
            allStates[allStates.endIndex-1] = zeroCount
        }
        return allStates.reduce(0, +)
    }

    // Initial brute force approach for part 1
    private func part1_bruteforce() {
        var school = initial
        for _ in 1...80 {
            var newSchool = [Int]()
            var newbornCount = 0
            for fish in school {
                let newFish = fish - 1
                if fish > 0 {
                    newSchool.append(newFish)
                } else {
                    newSchool.append(6)
                    newbornCount += 1
                }
            }
            newSchool.append(contentsOf: Array(repeating: 8, count: newbornCount))
            school = newSchool
        }
        print(school.count)
    }
}
