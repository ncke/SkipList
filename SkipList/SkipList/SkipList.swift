//
//  SkipList.swift
//  SkipList
//
//  Created by Nick on 12/02/2019.
//  Copyright © 2019 Nick. All rights reserved.
//

import Foundation

struct SkipList<Key: Comparable, Value: Any> {
    
    private struct Forward {
        var forward: [Node?]
        subscript(_ index: Int) -> Node? { return forward[index] }
        init(levels: Int) { forward = (0..<levels).map { _ in return nil } }
    }
    
    private struct Node: Comparable {
        let key: Key?
        let value: Value?
        let forward: Forward
        
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
    
    private var list = [Node]()
    private var maxLevels = 5
    
    init() {
        list = [ Node(key: nil, value: nil, forward: Forward(levels: maxLevels)) ]
    }
}

extension SkipList {
    
    private func search(key: Key) -> (Node, Node?) {
        guard var current = list.first else { fatalError() }
        
        for level in (0..<maxLevels).reversed() {
            
            while let x < x.forward(level) {
                x = x.forward(level)!
                
            }
        }
        
        let y = current.forward(0)
        
        return y?.key == key ? (x, y) : (x, nil)
    }
    
}