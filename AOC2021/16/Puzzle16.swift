//
//  Puzzle16.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

fileprivate class Packet: CustomStringConvertible {
    let version: Int
    let id: Int
    let value: Int?
    let subpackets: [Packet]

    init(version: Int, id: Int, value: Int? = nil, subpackets: [Packet] = []) {
        self.version = version
        self.id = id
        self.value = value
        self.subpackets = subpackets
    }

    var description: String {
        var str = "Version: \(version) ID: \(id)\n"
        if let value = value {
            str += "Value = \(value)\n"
        } else if subpackets.isEmpty {
            str += "No subpackets"
        } else {
            subpackets.enumerated().forEach {
                str += "\tPacket \($0.offset)"
                str += "\t\($0.element)"
            }
        }
        str += "\n"
        return str
    }
}

fileprivate let hex2bin: [Character: String] = [
    "0": "0000",
    "1": "0001",
    "2": "0010",
    "3": "0011",
    "4": "0100",
    "5": "0101",
    "6": "0110",
    "7": "0111",
    "8": "1000",
    "9": "1001",
    "A": "1010",
    "B": "1011",
    "C": "1100",
    "D": "1101",
    "E": "1110",
    "F": "1111"
]

struct Puzzle16: Puzzle {
    private let input: [Character]

    init() {
        let hexInput = InputFileReader.read("Input16-test")[0]
        input = hexInput.flatMap { hex2bin[$0]! }
    }

    func part1() {
        var offset = 0
        print(parsePacket(offset: &offset))
    }

    func part2() {

    }

    private func parsePacket(offset: inout Int) -> Packet {
        let version = Int(String(input[offset..<offset+3]), radix: 2)!
        let id = Int(String(input[offset+3..<offset+6]), radix: 2)!
        offset += 6
        if id == 4 {
            let value = parseLiteralValue(offset: &offset)
            return Packet(version: version, id: id, value: value)
        } else {
            fatalError("ID \(id) not yet supported")
        }
    }

    private func parseLiteralValue(offset: inout Int) -> Int {
        var endOffset = offset
        repeat {
            endOffset += 5
        } while input[endOffset] != "0"
        var value = ""
        for offset in stride(from: offset, to: endOffset+1, by: 5) {
            value.append(contentsOf: input[offset+1..<offset+5])
        }
        offset = endOffset
        return Int(String(value), radix: 2)!
    }
}
