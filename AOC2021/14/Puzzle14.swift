//
//  Puzzle14.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

import Algorithms

fileprivate struct Pair: ExpressibleByStringLiteral, Hashable, CustomStringConvertible {
    let fst, snd: Character
    var description: String { "\(fst)\(snd)" }

    init(stringLiteral value: StringLiteralType) {
        guard value.count == 2 else { fatalError("value.count != 2") }
        fst = value.first!
        snd = value.last!
    }

    init(_ pair: (Character, Character)) {
        self.fst = pair.0
        self.snd = pair.1
    }
}

struct Puzzle14: Puzzle {
    private let template: String
    private let rules: [Pair: Character]

    init() {
        let input = InputFileReader.read("Input14")
        self.template = input[0]
        var rules = [Pair: Character]()
        for line in input.dropFirst() {
            let split = line.components(separatedBy: " -> ")
            rules[Pair(stringLiteral: split[0])] = Character(split[1])
        }
        self.rules = rules
    }

    func part1() {
        let initialPairs = template.adjacentPairs().map(Pair.init)
        var pairCounts = [Pair: Int]()
        for pair in initialPairs {
            let count = pairCounts[pair, default: 0]
            pairCounts[pair] = (count + 1)
        }
        for i in 1...40 {
            pairCounts = expand(pairCounts)
            if i == 10 {
                print(answer(pairCounts))
            }
        }
        print(answer(pairCounts))
    }

    func part2() { /* Done in part 1 */ }

    private func expand(_ pairCounts: [Pair: Int]) -> [Pair: Int] {
        var expanded = [Pair: Int]()
        for (pair, count) in pairCounts {
            guard let sub = rules[pair] else {
                fatalError("No insertion char found for \(pair)")
            }
            let newPair1 = Pair((pair.fst, sub))
            let newPair2 = Pair((sub, pair.snd))
            let newPair1Count = expanded[newPair1, default: 0]
            expanded[newPair1] = (newPair1Count + count)
            let newPair2Count = expanded[newPair2, default: 0]
            expanded[newPair2] = (newPair2Count + count)
        }
        return expanded
    }

    private func answer(_ pairCounts: [Pair: Int]) -> Int {
        var charCounts = [Character: Int]()
        for (pair, count) in pairCounts {
            let charCountFst = charCounts[pair.fst, default: 0]
            charCounts[pair.fst] = (charCountFst + count)
            let charCountSnd = charCounts[pair.snd, default: 0]
            charCounts[pair.snd] = (charCountSnd + count)
        }
        for (char, count) in charCounts {
            if char == template.first! || char == template.last! {
                charCounts[char] = (count + 1) / 2
            } else {
                charCounts[char] = count / 2
            }
        }
        let sortedCounts = charCounts.values.sorted(by: >)
        return sortedCounts.first! - sortedCounts.last!
    }

    // Brute force approach that expands polymer string as is.
    // Fails miserably for part 2
    private func expand(_ polymer: String) -> String {
        var new = String(polymer.first!)
        for pair in polymer.adjacentPairs().map(Pair.init) {
            guard let char = rules[pair] else {
                fatalError("No insertion char found for \(pair)")
            }
            new.append("\(char)\(pair.fst)")
        }
        return new
    }
}
