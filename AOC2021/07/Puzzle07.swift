//
//  Puzzle07.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle07: Puzzle {
    //private let initial = [16,1,2,0,4,2,7,1,2,14]
    private let initial = InputFileReader.read("Input07")[0].components(separatedBy: ",").compactMap(Int.init)

    func part1() {
        let cheapest = cheapestPos { from, to in
            abs(from - to)
        }
        print(cheapest)
    }

    func part2() {
        let cheapest = cheapestPos { from, to in
            let diff = abs(from - to)
            return diff * (diff + 1) / 2
        }
        print(cheapest)
    }

    private func cheapestPos(fuelCalc: (Int, Int) -> Int) -> Int {
        let maxPos = initial.max()!
        var currentMin = Int.max
        for alignPos in 0...maxPos {
            var fuelCost = 0
            for toMove in initial {
                fuelCost += fuelCalc(alignPos, toMove)
            }
            currentMin = min(fuelCost, currentMin)
        }
        return currentMin
    }
}
