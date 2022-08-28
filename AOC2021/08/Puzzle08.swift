//
//  Puzzle08.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle08: Puzzle {
    let input = InputFileReader.read("Input08")

    func part1() {
        let onSegments = input.map { $0.components(separatedBy: " | ")[1].components(separatedBy: " ") }
        let easyDigits = onSegments.flatMap { $0 }.filter(isDigitEasy)
        print(easyDigits.count)
    }

    func part2() {
        var sum = 0
        for line in input {
            let split = line.components(separatedBy: " | ")
            let patterns = Set(split[0].components(separatedBy: " ").map(Set.init))
            let output = split[1].components(separatedBy: " ").map(Set.init)
            let mapping = deduceMapping(patterns)
            let result = Int(output.map { "\(mapping[$0]!)" }.joined())!
            sum += result
        }
        print(sum)
    }

    private func isDigitEasy(_ digit: String) -> Bool {
        digit.count == 2 || digit.count == 3 || digit.count == 4 || digit.count == 7
    }

    private func deduceMapping(_ patterns: Set<Set<Character>>) -> [Set<Character>: Int] {
        var mapping: [Set<Character>: Int] = [:]
        var fiveCountPatterns = Set<Set<Character>>()
        var sixCountPatterns = Set<Set<Character>>()
        var onePattern, fourPattern: Set<Character>?
        for pattern in patterns {
            if pattern.count == 2 {
                mapping[pattern] = 1
                onePattern = pattern
            } else if pattern.count == 3 {
                mapping[pattern] = 7
            } else if pattern.count == 4 {
                mapping[pattern] = 4
                fourPattern = pattern
            } else if pattern.count == 5 {
                fiveCountPatterns.insert(pattern)
            } else if pattern.count == 6 {
                sixCountPatterns.insert(pattern)
            }  else if pattern.count == 7 {
                mapping[pattern] = 8
            }
        }

        // 6d superset 4 = 9
        let nineSet = sixCountPatterns.filter { $0.isSuperset(of: fourPattern!) }
        guard nineSet.count == 1, let nine = nineSet.randomElement() else {
            fatalError("6d superset 4 != 9")
        }
        mapping[nine] = 9

        // remaining 6d superset 1 = 0
        sixCountPatterns.remove(nine)
        let zeroSet = sixCountPatterns.filter { $0.isSuperset(of: onePattern!) }
        guard zeroSet.count == 1, let zero = zeroSet.randomElement() else {
            fatalError("remaining 6d superset 1 != 0")
        }
        mapping[zero] = 0

        // remaining 6d = 6
        sixCountPatterns.remove(zero)
        guard sixCountPatterns.count == 1, let six = sixCountPatterns.randomElement() else {
            fatalError("remaining 6d != 6")
        }
        mapping[six] = 6

        // 5d superset 1 = 3
        let threeSet = fiveCountPatterns.filter { $0.isSuperset(of: onePattern!) }
        guard threeSet.count == 1, let three = threeSet.randomElement() else {
            fatalError("5d superset 1 != 3")
        }
        mapping[three] = 3

        // remaining 5d subset 6 = 5
        fiveCountPatterns.remove(three)
        let fiveSet = fiveCountPatterns.filter { $0.isSubset(of: six) }
        guard fiveSet.count == 1, let five = fiveSet.randomElement() else {
            fatalError("remaining 5d subset 6 != 5")
        }
        mapping[five] = 5

        // remaining 5d = 2
        fiveCountPatterns.remove(five)
        guard fiveCountPatterns.count == 1, let two = fiveCountPatterns.randomElement() else {
            fatalError("remaining 5d = 2")
        }
        mapping[two] = 2
        return mapping
    }
}
