//
//  main.swift
//  SkipList
//
//  Created by Nick on 12/02/2019.
//  Copyright © 2019 Nick. All rights reserved.
//

import Foundation

print("Skip List Demo")

let quote = """
It was one of those March days when the sun shines hot and the wind
blows cold: when it is summer in the light, and winter in the shade.
"""

print("Quote -- \(quote)")
let words = quote.components(separatedBy: .whitespacesAndNewlines)

// Create a skip list.
let skip = SkipList<Int, String>()

// Load the skip list.
for (i, word) in words.enumerated() {
    skip[i] = word
}

// Update an item.
guard let previous5 = skip.insert(key: 5, value: "September") else {
    fatalError("Word not found!")
}
print("The previous value was \(previous5)")

// Update using subscript syntax.
skip[5] = "October"

// Remove items.
guard let previous9 = skip.remove(key: 9) else {
    fatalError("Word not found!")
}
print("The previous value was \(previous9)")

// Remove items using subscript syntax.
skip[8] = nil; skip[10] = nil; skip[11] = nil; skip[12] = nil

// Retrieve thirty words.
for i in 0..<30 {
    let word = skip[i] ?? "<nil>"
    print("Word: \(i) is \(word)")
}
