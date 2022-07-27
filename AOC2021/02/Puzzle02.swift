//
//  Puzzle02.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle02: Puzzle {
    private let commands = InputFileReader.read("Input02")

    func part1() {
        var h = 0, v = 0 // h is horizontal position, v is depth
        for command in commands {
            let split = command.split(separator: " ")
            let cmd = split[0]
            let num = Int(split[1])!
            if cmd == "forward" {
                h += num
            } else if cmd == "up" {
                v -= num
            } else if cmd == "down" {
                v += num
            } else {
                fatalError("Invalid command \(command)")
            }
        }
        print(h * v)
    }

    func part2() {
        var a = 0, h = 0, v = 0 // a is aim, h is horizontal position, v is depth
        for command in commands {
            let split = command.split(separator: " ")
            let cmd = split[0]
            let num = Int(split[1])!
            if cmd == "forward" {
                h += num
                v += (a * num)
            } else if cmd == "up" {
                a -= num
            } else if cmd == "down" {
                a += num
            } else {
                fatalError("Invalid command \(command)")
            }
        }
        print(h * v)
    }
}
