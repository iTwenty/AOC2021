//
//  Puzzle03.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

struct Puzzle03: Puzzle {
    let nums = InputFileReader.read("Input03").map(Array.init)

    func part1() {
        let charCount = nums[0].count
        var gammaString = "", epsilonString = ""
        for i in 0..<charCount {
            let bits = gammaAndEpsilonBit(at: i)
            gammaString.append(bits.0)
            epsilonString.append(bits.1)
        }
        let gamma = Int(gammaString, radix: 2)!
        let epsilon = Int(epsilonString, radix: 2)!
        print(gamma * epsilon)
    }

    func part2() {
        let ogrString = ogr(nums)
        let csrString = csr(nums)
        let ogr = Int(ogrString, radix: 2)!
        let csr = Int(csrString, radix: 2)!
        print(ogr * csr)
    }

    private func gammaAndEpsilonBit(at position: Int) -> (Character, Character) {
        let (zeros, ones) = separateZerosAndOnes(nums, position: position)
        return ones.count > zeros.count ? ("1", "0") : ("0", "1")
    }

    private func ogr(_ nums: [[Character]], position: Int = 0) -> String {
        if nums.count == 1 {
            return String(nums[0])
        }
        let (zeros, ones) = separateZerosAndOnes(nums, position: position)
        if ones.count >= zeros.count {
            return ogr(ones, position: position + 1)
        } else {
            return ogr(zeros, position: position + 1)
        }
    }

    private func csr(_ nums: [[Character]], position: Int = 0) -> String {
        if nums.count == 1 {
            return String(nums[0])
        }
        let (zeros, ones) = separateZerosAndOnes(nums, position: position)
        if zeros.count <= ones.count {
            return csr(zeros, position: position + 1)
        } else {
            return csr(ones, position: position + 1)
        }
    }

    private func separateZerosAndOnes(_ nums: [[Character]], position: Int) -> ([[Character]], [[Character]]) {
        let bitsForPosition = nums.map { $0[position] }
        var (zeros, ones) = ([[Character]](), [[Character]]())
        for (index, b) in bitsForPosition.enumerated() {
            if b == "0" {
                zeros.append(nums[index])
            } else {
                ones.append(nums[index])
            }
        }
        return (zeros, ones)
    }
}
