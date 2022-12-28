//
//  Puzzle20.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle20: Puzzle {
    private let algorithm: [Character]
    private let image: [Point: Character]
    // Whether to toggle between light and dark for out of bounds pixels
    private let flipVoid: Bool

    init() {
        let input = InputFileReader.read("Input20")
        self.algorithm = Array(input.first!)
        var image = [Point: Character]()
        input.dropFirst().enumerated().forEach { (y, row) in
            row.enumerated().forEach { (x, pixel) in
                image[Point(x: x, y: y)] = pixel
            }
        }
        self.image = image
        flipVoid = (self.algorithm.first == "#")
    }

    func part1() {
        let enhanced = enhance(image, times: 2)
        print(enhanced.values.filter { $0 == "#" }.count)
    }

    func part2() {
        let enhanced = enhance(image, times: 50)
        print(enhanced.values.filter { $0 == "#" }.count)
    }

    private func enhance(_ image: [Point: Character], times: Int) -> [Point: Character] {
        var enhanced = image
        for i in 0..<times {
            print(i) // To get an indication of progress for part 2
            enhanced = enhance(enhanced, void: (flipVoid && i % 2 != 0) ? "#" : ".")
        }
        return enhanced
    }

    private func enhance(_ image: [Point: Character], void: Character) -> [Point: Character] {
        let (min, max) = (image.keys.min()!, image.keys.max()!)
        var newImage = [Point: Character]()
        for y in min.y-1...max.y+1 {
            for x in min.x-1...max.y+1 {
                let point = Point(x: x, y: y)
                let newPixel = newPixel(at: point, in: image, void: void)
                newImage[point] = newPixel
            }
        }
        return newImage
    }

    private func newPixel(at position: Point, in image: [Point: Character], void: Character) -> Character {
        let neighbours = neighbours(of: position, in: image, void: void)
        let index = pixels2index(neighbours)
        return algorithm[index]
    }

    private func neighbours(of position: Point, in image: [Point: Character], void: Character) -> [Character] {
        var neighbours = [Character]()
        for y in (position.y-1)...(position.y+1) {
            for x in (position.x-1)...(position.x+1) {
                neighbours.append(image[Point(x: x, y: y), default: void])
            }
        }
        return neighbours
    }

    private func pixels2index(_ pixels: [Character]) -> Int {
        let binary: [Character] = pixels.map { $0 == "." ? "0" : "1" }
        return Int(String(binary), radix: 2)!
    }

    private func printImage(_ image: [Point: Character]) {
        let (min, max) = (image.keys.min()!, image.keys.max()!)
        for y in min.y...max.y {
            var line = ""
            for x in min.x...max.x {
                line.append(String(image[Point(x: x, y: y), default: "."]))
            }
            print(line)
        }
        print("\n")
    }
}
