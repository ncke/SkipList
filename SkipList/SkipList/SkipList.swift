//
//  SkipList.swift
//  SkipList
//
//  Created by Nick Everitt on 12/02/2019.
//  Copyright © 2019 Nick Everitt. All rights reserved.
//

import Foundation

struct SkipList<Key: Comparable, Value: Any> {
    
    private struct Links {
        var links: [Node?]
        subscript(_ index: Int) -> Node? {
            get { return links[index] }
            mutating set(newValue) { links[index] = newValue }
        }
        init(levels: Int) { links = (0..<levels).map { _ in return nil } }
    }
    
    private struct Node: Comparable {
        let key: Key?
        var value: Value?
        var forward: Links
        
        func forward(_ level: Int) -> Node? { return forward[level] }
        
        static func < (lhs: SkipList<Key, Value>.Node, rhs: SkipList<Key, Value>.Node) -> Bool {
            guard let left = lhs.key else { return true }
            guard let right = rhs.key else { return false }
            return left < right
        }
        
        static func == (lhs: SkipList<Key, Value>.Node, rhs: SkipList<Key, Value>.Node) -> Bool {
            return lhs.key == rhs.key
        }
    }
    
    private var header: Node
    private var maxLevels = 5
    private var p = 0.33
    
    init() {
        header = Node(key: nil, value: nil, forward: Links(levels: maxLevels))
    }
}

extension SkipList {
    
    private func search(key: Key) -> (Node, Node?) {
        var x = header
        
        for level in (0..<maxLevels).reversed() {
            while let next = x.forward(level), x < next { x = next }
        }
        
        let next = x.forward(0)
        return next?.key == key ? (x, next) : (x, nil)
    }
    
    private func search(key: Key) -> (Node, Node?, Links) {
        var x = header
        var backward = Links(levels: maxLevels)
        
        for level in (0..<maxLevels).reversed() {
            while let next = x.forward(level), x < next { x = next }
            backward[level] = x
        }
        
        let next = x.forward(0)
        return next?.key == key ? (x, next, backward) : (x, nil, backward)
    }
    
    private func randomLevel() -> Int {
        var level = 1
        while Double.random(in: 0...1) < p { level += 1 }
        return min(level, maxLevels)
    }
    
    func insert(key: Key, value: Value) {
        var (_, actual, backward) = search(key: key)
        
        guard actual == nil else {
            actual?.value = value
            return
        }
        
        let forward = Links(levels: maxLevels)
        var newNode = Node(key: key, value: value, forward: forward)
        
        for i in 0..<randomLevel() {
            var incoming = backward[i] ?? header
            newNode.forward[i] = incoming
            incoming.forward[i] = newNode
        }
    }

    func delete(key: Key) {
        
    }
}

extension SkipList {
    
    subscript(_ key: Key) -> Value? {
        get {
            let (_, actual) = search(key: key)
            return actual?.value
        }
        set(newValue) {
            guard let newValue = newValue else {
                delete(key: key)
                return
            }
            
            insert(key: key, value: newValue)
        }
    }
}
