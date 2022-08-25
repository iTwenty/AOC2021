//
//  Puzzle04.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

import Darwin

fileprivate enum BoardState: Equatable {
    case normal, wonByRow(Position), wonByCol(Position)
}

fileprivate struct Position: Hashable, CustomStringConvertible {
    let row, col: Int
    var description: String { "(\(row), \(col))" }
}

fileprivate class Board {
    let nums: [[Int]]
    var marked: Set<Position>
    private var state: BoardState

    init(_ nums: [[Int]]) {
        self.nums = nums
        self.marked = []
        self.state = .normal
    }

    func mark(_ num: Int) -> BoardState {
        if state != .normal {
            return state
        }
        var position: Position?
        for (rowIndex, row) in nums.enumerated() {
            for (colIndex, boardNum) in row.enumerated() {
                if num == boardNum {
                    position = Position(row: rowIndex, col: colIndex)
                    marked.insert(position!)
                }
            }
        }
        guard let position = position else {
            self.state = .normal
            return self.state
        }
        if (0..<nums.count).allSatisfy({ marked.contains(Position(row: position.row, col: $0)) }) {
            self.state = .wonByCol(position)
            return self.state
        }
        if (0..<nums.count).allSatisfy({ marked.contains(Position(row: $0, col: position.col)) }) {
            self.state = .wonByRow(position)
            return self.state
        }
        self.state = .normal
        return self.state
    }

    func score(_ winningNum: Int) -> Int {
        var unmarkedSum = 0
        for (rIndex, row) in nums.enumerated() {
            for (cIndex, num) in row.enumerated() {
                if !marked.contains(Position(row: rIndex, col: cIndex)) {
                    unmarkedSum += num
                }
            }
        }
        return unmarkedSum * winningNum
    }
}

struct Puzzle04: Puzzle {
    private let nums: [Int]
    private let boards: [Board]

    init() {
        let lines = InputFileReader.read("Input04", omitEmptySubsequences: false)
        self.nums = lines[0].components(separatedBy: ",").compactMap(Int.init)
        var boards = [Board]()
        var boardNums = [[Int]]()
        for line in lines.dropFirst() {
            if line.isEmpty, !boardNums.isEmpty {
                boards.append(Board(boardNums))
                boardNums.removeAll()
            } else {
                let lineNums = line.components(separatedBy: " ").compactMap(Int.init)
                if !lineNums.isEmpty {
                    boardNums.append(lineNums)
                }
            }
        }
        self.boards = boards
    }

    func part1() {
        let winning = findFirstWinningBoard()
        guard let (board, num) = winning else {
            return
        }
        print(board.score(num))
    }

    func part2() {
        let winning = findLastWinningBoard()
        guard let (board, num) = winning else {
            return
        }
        print(board.score(num))
    }

    private func findFirstWinningBoard() -> (Board, Int)? {
        for num in nums {
            for board in boards {
                let state = board.mark(num)
                if state != .normal {
                    return (board, num)
                }
            }
        }
        return nil
    }

    private func findLastWinningBoard() -> (Board, Int)? {
        var remainingBoards = boards
        for num in nums {
            var newRemainingBoards = [Board]()
            for board in remainingBoards {
                let state = board.mark(num)
                if state == .normal {
                    newRemainingBoards.append(board)
                } else if remainingBoards.count == 1 {
                    return (board, num)
                }
            }
            remainingBoards = newRemainingBoards
        }
        return nil
    }
}
