//
//  Puzzle01.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle01: Puzzle {
    private let depths: [Int]

    init() {
        depths = InputFileReader.read("Input01").compactMap(Int.init)
    }

    func part1() {
        var increasing = 0
        for i in (1..<depths.endIndex) {
            let diff = depths[i] - depths[i - 1]
            if diff > 0 {
                increasing += 1
            }
        }
        print(increasing)
    }

    func part2() {
        var increasing = 0
        for i in (1..<depths.endIndex-2) {
            let diff = (depths[i]+depths[i+1]+depths[i+2]) - (depths[i-1]+depths[i]+depths[i+1])
            if diff > 0 {
                increasing += 1
            }
        }
        print(increasing)
    }
}
