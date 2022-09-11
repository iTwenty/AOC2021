//
//  Puzzle13.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

typealias Paper = [[Character]]

fileprivate struct Fold: CustomStringConvertible {
    let horizontal: Bool
    let line: Int
    var description: String { "\(horizontal ? "y" : "x")=\(line)" }
}

struct Puzzle13: Puzzle {
    // maxX found by running cut -d , -f 1 Input13 | sort -n
    // maxY found by running cut -d , -f 2 Input13 | sort -n
    private let maxX = 1311
    private let maxY = 895
    // Use below values for running against test input
    // private let maxX = 11
    // private let maxY = 15
    private let paper: Paper
    private let folds: [Fold]

    init() {
        var paper = Array(repeating: Array(repeating: Character("."), count: maxX), count: maxY)
        var folds = [Fold]()
        var parsingFolds = false
        for line in InputFileReader.read("Input13", separator: "\n", omitEmptySubsequences: false) {
            if line.isEmpty {
                parsingFolds = true
            } else if parsingFolds {
                let split = line.components(separatedBy: "=")
                let fold = Fold(horizontal: split[0] == "y", line: Int(split[1])!)
                folds.append(fold)
            } else {
                let split = line.components(separatedBy: ",")
                paper[Int(split[1])!][Int(split[0])!] = "#"
            }
        }
        self.paper = paper
        self.folds = folds
    }

    func part1() {
        let folded = fold(paper, along: folds[0])
        let dotsCount = folded.flatMap { $0 }.filter { $0 == "#" }.count
        print(dotsCount)
    }

    func part2() {
        var folded = paper
        for f in folds {
            folded = fold(folded, along: f)
        }
        folded.forEach { print(String($0)) }
    }

    private func fold(_ paper: Paper, along fold: Fold) -> Paper {
        if fold.horizontal {
            guard paper[fold.line].allSatisfy({ $0 != "#" }) else {
                fatalError("Found a dot on fold line \(fold)")
            }
            return foldHorizontal(paper, along: fold.line)
        } else {
            guard paper.allSatisfy({ $0[fold.line] != "#" }) else {
                fatalError("Found a dot on fold line \(fold)")
            }
            return foldVertical(paper, along: fold.line)
        }
    }

    private func foldHorizontal(_ paper: Paper, along index: Int) -> Paper {
        guard index == (paper.endIndex - 1) / 2 else {
            fatalError("Line \(index) not halfway vertical on paper")
        }
        var newPaper = Array(paper[paper.startIndex..<(paper.endIndex-1) / 2])
        for (row, line) in paper[index..<paper.endIndex].enumerated() {
            for (col, char) in line.enumerated() {
                if char == "#" {
                    newPaper[newPaper.endIndex - row][col] = char
                }
            }
        }
        return newPaper
    }

    private func foldVertical(_ paper: Paper, along index: Int) -> Paper {
        guard index == (paper[0].endIndex - 1) / 2 else {
            fatalError("Line \(index) not halfway horizontal on paper")
        }

        var newPaper = paper.map { Array($0[$0.startIndex..<($0.endIndex-1) / 2]) }
        for (row, line) in paper.enumerated() {
            for (col, char) in line[index..<line.endIndex].enumerated() {
                if char == "#" {
                    newPaper[row][newPaper[0].endIndex - col] = char
                }
            }
        }
        return newPaper
    }
}
