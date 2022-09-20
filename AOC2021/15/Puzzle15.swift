//
//  Puzzle15.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle15: Puzzle {
    private let risks: [[Int]]
    let maxX, maxY: Int

    init() {
        risks = InputFileReader.read("Input15").map { line in
            line.compactMap { $0.wholeNumberValue }
        }
        maxX = risks[0].count
        maxY = risks.count
    }

    func part1() {
        
    }

    func part2() {

    }
}
