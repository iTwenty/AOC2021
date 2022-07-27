// 
//  InputFileReader.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

import Foundation

class InputFileReader {

    /// Reads an input file with given name and returns it's contents as a String array. The file is read from
    /// Input.bundle which should be present in same directory as main executable during runtime.
    static func read(_ file: String, separator: Character = "\n", omitEmptySubsequences: Bool = true) -> [String] {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleUrl = URL(fileURLWithPath: "Input.bundle", relativeTo: currentDirectoryURL)
        let bundle = Bundle(url: bundleUrl)
        let inputFileUrl = bundle!.url(forResource: file, withExtension: nil)!
        let contents = try! String(contentsOf: inputFileUrl, encoding: .utf8)
        let input: [String] = contents.split(separator: separator,
                                             maxSplits: Int.max,
                                             omittingEmptySubsequences: omitEmptySubsequences).map(String.init)
        return input
    }
}
