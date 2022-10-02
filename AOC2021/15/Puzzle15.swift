//
//  Puzzle15.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 27/07/22.
//

// Stores algorithm specific info like current min cost and previous point
// via which the point has been reached. Intended to be used as value in
// [Point: Node] dict during Dijkstra's shortest path algorithm.
fileprivate class Node: CustomStringConvertible, Comparable {
    let point: Point
    var prev: Point?
    var cost: Int

    init(point: Point, cost: Int = Int.max) {
        self.point = point
        self.cost = cost
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.cost == rhs.cost
    }

    static func < (lhs: Node, rhs: Node) -> Bool {
        lhs.cost < rhs.cost
    }

    var description: String { "Cost : \(cost), Prev: \(prev?.description ?? "nil")" }
}

fileprivate class Map {
    let risks: [[Int]]
    let big: Bool
    let maxX, maxY: Int
    let xRange, yRange: Range<Int>
    let start, end: Point

    init(_ risks: [[Int]], big: Bool) {
        self.risks = risks
        self.big = big
        self.maxX = risks[0].endIndex
        self.maxY = risks.endIndex
        self.xRange = big ? (0..<maxX * 5) : (0..<maxX)
        self.yRange = big ? (0..<maxY * 5) : (0..<maxY)
        self.start = Point(x: 0, y: 0)
        self.end = big ? Point(x: maxX * 5 - 1, y: maxY * 5 - 1) : Point(x: maxX - 1, y: maxY - 1)
    }

    func neighbourPoints(_ point: Point) -> [Point] {
        let xyDiffs = [(-1,0), (0,-1), (0,+1), (+1,0)]
        let neighourPoints = xyDiffs.compactMap { (x, y) -> Point? in
            let neighbourX = point.x + x
            let neighbourY = point.y + y
            if xRange.contains(neighbourX), yRange.contains(neighbourY) {
                return Point(x: neighbourX, y: neighbourY)
            } else {
                return nil
            }
        }
        return neighourPoints
    }

    func cost(_ point: Point) -> Int {
        guard big else {
            return risks[point.x][point.y]
        }
        let divX = point.x / maxX
        let modX = point.x % maxX
        let divY = point.y / maxY
        let modY = point.y % maxY
        let baseCost = risks[modY][modX]
        let newCost = baseCost + (divX + divY)
        return (newCost - 1) % 9 + 1
    }
}

struct Puzzle15: Puzzle {
    private let risks: [[Int]]

    init() {
        risks = InputFileReader.read("Input15").map { line in
            line.compactMap { $0.wholeNumberValue }
        }
    }

    func part1() {
        let map = Map(self.risks, big: false)
        print(shortestPath(map: map, nodes: shortestPathDijkstra(map)))
    }

    func part2() {
        let map = Map(self.risks, big: true)
        print(shortestPath(map: map, nodes: shortestPathDijkstra(map)))
    }

    private func shortestPathDijkstra(_ map: Map) -> [Point: Node] {
        var visitedNodes = [Point: Node]()
        var unvisitedNodes = [Point: Node]()
        var frontier = PriorityQueue<Node>(elements: [Node(point: map.start, cost: 0)])
        while let currentNode = frontier.dequeue() {
            let currentPoint = currentNode.point
            visitedNodes[currentPoint] = currentNode
            let unvisitedNeighbourPoints = map.neighbourPoints(currentPoint).filter { !visitedNodes.keys.contains($0) }
            for unvisitedNeighbourPoint in unvisitedNeighbourPoints {
                let costViaCurrentNode = currentNode.cost + map.cost(unvisitedNeighbourPoint)
                if let unvisitedNeighbourNode = unvisitedNodes[unvisitedNeighbourPoint] {
                    if costViaCurrentNode < unvisitedNeighbourNode.cost {
                        unvisitedNeighbourNode.cost = costViaCurrentNode
                        unvisitedNeighbourNode.prev = currentNode.point
                        frontier.enqueue(unvisitedNeighbourNode)
                    }
                } else {
                    let neighbourNode = Node(point: unvisitedNeighbourPoint, cost: costViaCurrentNode)
                    neighbourNode.prev = currentNode.point
                    unvisitedNodes[unvisitedNeighbourPoint] = neighbourNode
                    frontier.enqueue(neighbourNode)
                }
            }
        }
        return visitedNodes
    }

    private func shortestPath(map: Map, nodes: [Point: Node]) -> ([Point], Int) {
        guard nodes.keys.contains(map.end) else {
            return ([], Int.max)
        }
        var path = [Point]()
        var currentPoint = map.end
        while currentPoint != map.start {
            guard let currentNode = nodes[currentPoint], let prevPoint = currentNode.prev else {
                fatalError("No node for point \(currentPoint)")
            }
            path.append(currentPoint)
            currentPoint = prevPoint
        }
        path.append(map.start)
        return (path.reversed(), nodes[map.end]!.cost)
    }
}
