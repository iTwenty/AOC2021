//
//  Puzzle10.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

enum LineState {
    case complete
    case incomplete(remaining: [Character])
    case corrupt(index: Int, expected: Character, found: Character)
}

struct Puzzle10: Puzzle {
    private let lines = InputFileReader.read("Input10")

    func part1() {
        let total = lines.reduce(0) { acc, line in
            let state = state(line)
            switch state {
            case .corrupt(_, _, let found): return acc + corruptPoints(found)
            default: return acc
            }
        }
        print(total)
    }

    func part2() {
        let incompleteScores = lines.compactMap { line -> Int? in
            switch state(line) {
            case .incomplete(let remaining):  return incompleteScore(remaining)
            default: return nil
            }
        }
        let midIndex = (incompleteScores.endIndex - 1) / 2
        print(incompleteScores.sorted()[midIndex])
    }

    private func state(_ line: String) -> LineState {
        let openingChars = Set("([{<")
        var stack = [Character]()
        for (index, char) in line.enumerated() {
            if openingChars.contains(char) {
                stack.append(char)
            } else if let last = stack.last, char == closingChar(last) {
                stack.removeLast()
            } else {
                return .corrupt(index: index, expected: closingChar(stack.last!), found: char)
            }
        }
        if stack.isEmpty {
            return .complete
        } else {
            return .incomplete(remaining: stack.map(closingChar(_:)).reversed())
        }
    }

    private func closingChar(_ char: Character) -> Character {
        switch char {
        case "(": return ")"
        case "[": return "]"
        case "{": return "}"
        case "<": return ">"
        default:  fatalError("Invalid opening char \(char)")
        }
    }

    private func corruptPoints(_ char: Character) -> Int {
        switch char {
        case ")": return 3
        case "]": return 57
        case "}": return 1197
        case ">": return 25137
        default:  fatalError("No corrupt points defined for char \(char)")
        }
    }

    private func incompletePoints(_ char: Character) -> Int {
        switch char {
        case ")": return 1
        case "]": return 2
        case "}": return 3
        case ">": return 4
        default:  fatalError("No incomplete points defined for char \(char)")
        }
    }

    private func incompleteScore(_ chars: [Character]) -> Int {
        var score = 0
        for char in chars {
            score *= 5
            score += incompletePoints(char)
        }
        return score
    }
}
