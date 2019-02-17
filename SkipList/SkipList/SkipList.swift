//
//  SkipList.swift
//  SkipList
//
//  Created by Nick Everitt on 12/02/2019.
//  Copyright © 2019 Nick Everitt. All rights reserved.
//

import Foundation

class SkipList<Key: Comparable, Value: Any> {
    
    // MARK: -
    private struct Links {
        var links: [Node?]
        subscript(_ index: Int) -> Node? {
            get { return links[index] }
            mutating set(newValue) { links[index] = newValue }
        }
        init(levels: Int) { links = (0..<levels).map { _ in return nil } }
    }
    
    // MARK: -
    private class Node {
        let key: Key?
        var value: Value?
        var forward: Links
        
        init(key: Key?, value: Value?, forward: Links) {
            self.key = key
            self.value = value
            self.forward = forward
        }
        
        func forward(_ level: Int) -> Node? { return forward[level] }
    }
    
    // MARK: -
    private var header: Node
    private var maxLevels: Int
    private var p: Double
    
    /// Creates an empty skip list.
    /// - Parameters:
    ///     - maxLevels: The maximum number of skip levels maintained for a list item.
    ///         The default is 5.
    ///     - p: The coin toss probability for 'heads' used when determining the actual number of skip levels.
    ///         The default is 0.33.
    /// - Remark:
    /// See Pugh, D. (1990) 'Skip Lists: a Probabilistic Algernative to Balanced Trees',
    /// Communications of the ACM, Vol. 33, No. 6.
    init(maxLevels: Int = 5, p: Double = 0.33) {
        self.maxLevels = maxLevels
        self.p = p
        header = Node(key: nil, value: nil, forward: Links(levels: maxLevels))
    }
}

// MARK: -
extension SkipList {
    
    private func search(key searchKey: Key) -> (Node, Node?, Links) {
        var x = header
        var backward = Links(levels: maxLevels)
        
        for level in (0..<maxLevels).reversed() {
            while let next = x.forward(level), let nextKey = next.key, nextKey < searchKey { x = next }
            backward[level] = x
        }
        
        let next = x.forward(0)
        return next?.key == searchKey ? (x, next, backward) : (x, nil, backward)
    }
    
    private func randomLevel() -> Int {
        var level = 1
        while Double.random(in: 0...1) < p { level += 1 }
        return min(level, maxLevels)
    }
    
    /// Inserts a key-value pair into the skip list.
    ///
    /// If the key is found in the skip list, this method updates the value held for that key and
    /// returns the previously held value. Otherwise it inserts the key with the associated value.
    /// - Parameters:
    ///     - key: The key to insert.
    ///     - value: The value associated with the key.
    /// - Returns: The previously stored value for the key, or 'nil' if the key was not already present.
    /// - Complexity: O(log *n*), expected with high probability
    ///     where *n* is the number of key-value pairs in the skip list.
    func insert(key: Key, value: Value) -> Value? {
        var (_, actual, backward) = search(key: key)
        
        guard actual == nil else {
            let previous = actual?.value
            actual?.value = value
            return previous
        }
        
        let forward = Links(levels: maxLevels)
        let newNode = Node(key: key, value: value, forward: forward)
        
        for i in 0..<randomLevel() {
            let incoming = backward[i] ?? header
            newNode.forward[i] = incoming.forward[i]
            incoming.forward[i] = newNode
        }
        
        return nil
    }
    
    /// Removes a key and its associated value from the skip list.
    ///
    /// If the key is found in the skip list, this method returns the associated value and removes
    /// both the key and associated value from the list. Otherwise, if the key is not found, this
    /// method returns 'nil'.
    /// - Parameters:
    ///     - key: The key to remove along with its associated value.
    /// - Returns: The previously stored value for the deleted key, or 'nil' if the key was not present.
    /// - Complexity: O(log *n*), expected with high probability
    ///     where *n* is the number of key-value pairs in the skip list.
    func remove(key: Key) -> Value? {
        var (_, actual, backward) = search(key: key)
        
        guard let remove = actual else {
            return nil
        }
        
        for i in 0..<maxLevels {
            let incoming = backward[i] ?? header
            incoming.forward[i] = remove.forward[i]
        }
        
        return remove.value
    }
}

// MARK: -
extension SkipList {
    
    /// Accesses the value associated with the given key for reading and writing.
    subscript(_ key: Key) -> Value? {
        get {
            let (_, actual, _) = search(key: key)
            return actual?.value
        }
        set(newValue) {
            guard let newValue = newValue else {
                _ = remove(key: key)
                return
            }
            
            _ = insert(key: key, value: newValue)
        }
    }
}
