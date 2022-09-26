//
//  PriorityQueue.swift
//  AOC2021
//
//  Created by Jaydeep Joshi on 17/09/22.
//

import Foundation

struct PriorityQueue<Element> {
    private var elements: [Element]
    private var priorityFn: (Element, Element) -> Bool

    init<S: Sequence>(elements: S, priorityFn: @escaping (Element, Element) -> Bool) where S.Element == Element {
        self.elements = []
        self.priorityFn = priorityFn
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
        let maybeParentIndex = parentIndex(of: index)
        if let parentIndex = maybeParentIndex,
            isIndex(index, higherPriorityThanIndex: parentIndex) {
            elements.swapAt(index, parentIndex)
            siftUp(elementAtIndex: parentIndex)
        }
    }

    private mutating func siftDown(elementAtIndex index: Int) {
        let maybeLeftChildIndex = leftChildIndex(of: index)
        let maybeRightChildIndex = rightChildIndex(of: index)
        if let leftChildIndex = maybeLeftChildIndex,
           isIndex(leftChildIndex, higherPriorityThanIndex: index) {
            elements.swapAt(index, leftChildIndex)
            siftDown(elementAtIndex: leftChildIndex)
        } else if let rightChildIndex = maybeRightChildIndex,
                  isIndex(rightChildIndex, higherPriorityThanIndex: index) {
            elements.swapAt(index, rightChildIndex)
            siftDown(elementAtIndex: rightChildIndex)
        }
    }

    private func isIndex(_ firstIndex: Int, higherPriorityThanIndex secondIndex: Int) -> Bool {
        let first = elements[firstIndex]
        let second = elements[secondIndex]
        return priorityFn(first, second)
    }
}

extension PriorityQueue where Element: Comparable {
    init<S: Sequence>(elements: S) where S.Element == Element {
        self.elements = []
        self.priorityFn = (>)
        for element in elements {
            self.enqueue(element)
        }
    }
}

extension PriorityQueue: CustomStringConvertible {
    var description: String { self.elements.description }
}
