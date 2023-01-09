//
//  Puzzle21.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

fileprivate class Player: Hashable, CustomStringConvertible {
    static let p1 = Player(id: "1", score: 0, pos: 8)
    static let p2 = Player(id: "2", score: 0, pos: 3)

    let id: Character
    var score: Int
    var pos: Int

    init(id: Character, score: Int, pos: Int) {
        self.id = id
        self.score = score
        self.pos = pos
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(score)
        hasher.combine(pos)
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id && lhs.score == rhs.score && lhs.pos == rhs.score
    }

    var description: String { "Player \(id) is at position \(pos) with score \(score)" }
}

fileprivate class GameState: Hashable {
    var p1: Player
    var p2: Player
    private var curPlayer: Player
    var diceRollCount = 0
    private var curDiceValue = 0

    convenience init() {
        self.init(p1: Player.p1, p2: Player.p2)
    }

    init(p1: Player, p2: Player) {
        self.p1 = p1
        self.p2 = p2
        self.curPlayer = p1
    }

    func play() {
        let rolls = (rollDice(), rollDice(), rollDice())
        let sum = rolls.0 + rolls.1 + rolls.2
        let newPos = 1 + (curPlayer.pos + sum - 1) % 10
        curPlayer.pos = newPos
        curPlayer.score += newPos
        curPlayer = (curPlayer.id == p1.id ? p2 : p1)
    }

    private func rollDice() -> Int {
        var newDiceValue = curDiceValue + 1
        if newDiceValue == 101 {
            newDiceValue = 1
        }
        curDiceValue = newDiceValue
        diceRollCount += 1
        return curDiceValue
    }

    func loser() -> Player {
        if p1.score == p2.score {
            fatalError("Game tied")
        }
        if p1.score < p2.score {
            return p1
        }
        return p2
    }

    static func == (lhs: GameState, rhs: GameState) -> Bool {
        lhs.p1 == rhs.p1 && lhs.p2 == rhs.p2
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(p1)
        hasher.combine(p2)
    }
}

struct Puzzle21: Puzzle {

    func part1() {
        let game = GameState()
        while  game.p1.score < 1000, game.p2.score < 1000 {
            game.play()
        }
        print(game.diceRollCount * game.loser().score)
    }

    func part2() {

    }

    private func allPlayerStates(id: Character) -> [Player] {
        var players = [Player]()
        for position in 1...10 {
            for score in 0...20 {
                players.append(Player(id: id, score: score, pos: position))
            }
        }
        return players
    }
}
