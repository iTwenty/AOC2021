//
//  Puzzle12.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//


// TODO - Revisit later after learning a bit more about graph
// pathing algos
struct Puzzle12: Puzzle {
    private static let start = "start"
    private static let end = "end"
    private let graph: [String: Set<String>]

    init() {
        var graph = [String: Set<String>]()
        for line in InputFileReader.read("Input12-test") {
            let nodes = line.components(separatedBy: "-")
            Puzzle12.addEdge(from: nodes[0], to: nodes[1], in: &graph)
        }
        self.graph = graph
    }

    func part1() {
        print(findAllPaths(from: "start", to: "end", in: graph))
    }

    func part2() {

    }

    private func findAllPaths(from: String, to: String, in graph: [String: Set<String>]) -> Set<[String]> {
        var paths = Set<[String]>()
        var currentPath = [String]()
        var stack = [from]
        var smallVisited = Set<String>()
        while let current = stack.popLast() {
            if current == to {
                paths.insert(currentPath + [to])
            } else if !smallVisited.contains(current) {
                currentPath.append(current)
                stack.append(contentsOf: graph[current]!)
                smallVisited.insert(current)
            }
        }
        return paths
    }

    private static func addEdge(from: String, to: String, in graph: inout [String: Set<String>]) {
        var currentFromConnections = graph[from, default: []]
        var currentToConnections = graph[to, default: []]
        currentFromConnections.insert(to)
        currentToConnections.insert(from)
        graph[from] = currentFromConnections
        graph[to] = currentToConnections
    }
}
