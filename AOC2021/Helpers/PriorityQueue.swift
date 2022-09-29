//
//  PriorityQueue.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 17/09/22.
//

import Foundation

enum PriorityQueueType {
    case min, max
}

struct PriorityQueue<Element: Comparable> {
    private var elements: [Element]
    private var type: PriorityQueueType

    init<S: Sequence>(elements: S, type: PriorityQueueType = .min) where S.Element == Element {
        self.elements = []
        self.type = type
        for element in elements {
            self.enqueue(element)
        }
    }

    mutating func enqueue(_ element: Element) {
        elements.append(element)
        siftUp(elementAtIndex: elements.endIndex - 1)
    }

    mutating func dequeue() -> Element? {
        if elements.isEmpty { return nil }
        elements.swapAt(elements.startIndex, elements.endIndex - 1)
        let element = elements.removeLast()
        siftDown(elementAtIndex: elements.startIndex)
        return element
    }

    func peek() -> Element? { elements.first }
    var count: Int { elements.count }
}

// Helper private functions for queue
extension PriorityQueue {
    private func leftChildIndex(of index: Int) -> Int? {
        let maybeIndex = (2 * index) + 1
        return elements.indices.contains(maybeIndex) ? maybeIndex : nil
    }

    private func rightChildIndex(of index: Int) -> Int? {
        let maybeIndex = (2 * index) + 2
        return elements.indices.contains(maybeIndex) ? maybeIndex : nil
    }

    private func parentIndex(of index: Int) -> Int? {
        let maybeIndex = (index - 1) / 2
        return elements.indices.contains(maybeIndex) ? maybeIndex : nil
    }

    private mutating func siftUp(elementAtIndex index: Int) {
        if let parentIndex = parentIndex(of: index),
            isIndex(index, higherPriorityThanIndex: parentIndex) {
            elements.swapAt(index, parentIndex)
            siftUp(elementAtIndex: parentIndex)
        }
    }

    private mutating func siftDown(elementAtIndex index: Int) {
        if let higherPriorityChildIndex = higherPriorityChildIndex(for: index),
            isIndex(higherPriorityChildIndex, higherPriorityThanIndex: index) {
            elements.swapAt(index, higherPriorityChildIndex)
            siftDown(elementAtIndex: higherPriorityChildIndex)
        }
    }

    private func higherPriorityChildIndex(for parentIndex: Int) -> Int? {
        let maybeLeftChildIndex = leftChildIndex(of: parentIndex)
        let maybeRightChildIndex = rightChildIndex(of: parentIndex)
        if let leftChildIndex = maybeLeftChildIndex, let rightChildIndex = maybeRightChildIndex {
            return isIndex(leftChildIndex, higherPriorityThanIndex: rightChildIndex) ? leftChildIndex : rightChildIndex
        } else if maybeLeftChildIndex == nil, maybeRightChildIndex == nil {
            return nil
        } else {
            return maybeLeftChildIndex == nil ? maybeRightChildIndex! : maybeLeftChildIndex!
        }
    }

    private func isIndex(_ firstIndex: Int, higherPriorityThanIndex secondIndex: Int) -> Bool {
        let first = elements[firstIndex]
        let second = elements[secondIndex]
        switch type {
        case .min: return first < second
        case .max: return first > second
        }
    }
}

extension PriorityQueue: CustomStringConvertible {
    var description: String { self.elements.description }
}
