//
//  SkipListTests.swift
//  SkipListTests
//
//  Created by Nick on 14/02/2019.
//  Copyright © 2019 Nick. All rights reserved.
//

import XCTest

class SkipListTests: XCTestCase {
    
    func testSearchEmpty() {
        var s = SkipList<Int, Int>()
        XCTAssert(s[1000] == nil)
    }
    
    func testOneItem() {
        var s = SkipList<Int, Int>()
        s[1000] = 1
        XCTAssert(s[1000] == 1)
    }
    
    func testTwoItems() {
        var s = SkipList<Int, Int>()
        s[1000] = 23; s[2000] = 12
        
        XCTAssert(s[1000] == 23)
        XCTAssert(s[2000] == 12)
    }
    
    func testTwoItemsReverseInsert() {
        var s = SkipList<Int, Int>()
        s[2000] = 19; s[1000] = 74
        
        XCTAssert(s[1000] == 74)
        XCTAssert(s[2000] == 19)
    }
    
    func testOneItemOverwrite() {
        var s = SkipList<Int, Int>()
        s[1000] = 45; s[1000] = 67
        
        XCTAssert(s[1000] == 67)
    }
    
    func testOneItemDelete() {
        var s = SkipList<Int, Int>()
        s[1000] = 20
        XCTAssert(s[1000] == 20)
        s[1000] = nil
        XCTAssert(s[1000] == nil)
    }
    
    func testFirstItemDelete() {
        var s = SkipList<Int, Int>()
        s[1000] = 87; s[2000] = 90; s[3000] = 15; s[4000] = 25; s[5000] = 98
        XCTAssert(s[1000] == 87)
        s[1000] = nil
        XCTAssert(s[1000] == nil)
        XCTAssert(s[2000] == 90)
    }
    
    func testMiddleItemDelete() {
        var s = SkipList<Int, Int>()
        s[1000] = 87; s[2000] = 90; s[3000] = 15; s[4000] = 25; s[5000] = 98
        XCTAssert(s[3000] == 15)
        s[3000] = nil
        XCTAssert(s[3000] == nil)
        XCTAssert(s[2000] == 90)
        XCTAssert(s[4000] == 25)
    }
    
    func testLastItemDelete() {
        var s = SkipList<Int, Int>()
        s[1000] = 87; s[2000] = 90; s[3000] = 15; s[4000] = 25; s[5000] = 98
        XCTAssert(s[5000] == 98)
        s[5000] = nil
        XCTAssert(s[5000] == nil)
        XCTAssert(s[4000] == 25)
    }
    
    func testSearchNonExistent() {
        var s = SkipList<Int, Int>()
        s[1000] = 87; s[2000] = 90; s[3000] = 15; s[4000] = 25; s[5000] = 98
        XCTAssert(s[0] == nil)
        XCTAssert(s[2500] == nil)
        XCTAssert(s[9000] == nil)
    }
    
    func testRandomized() {
        var s = SkipList<Int, Int>()
        let listSize = Int.random(in: 100...1000)
        
        var expected = [Int: Int]()
        for _ in 1...listSize {
            let key = Int.random(in: 0...100000)
            let value = Int.random(in: 0...100000)
            s[key] = value
            expected[key] = value
        }
        
        for (_, x) in expected.enumerated() {
            XCTAssert(s[x.key] == x.value)
        }
    }

    func testLarge() {
        var s = SkipList<Int, Int>()
        let listSize = 10000
        
        var expected = [Int: Int]()
        for _ in 1...listSize {
            let key = Int.random(in: 0...100000)
            let value = Int.random(in: 0...100000)
            s[key] = value
            expected[key] = value
        }
        
        for (_, x) in expected.enumerated() {
            XCTAssert(s[x.key] == x.value)
        }
    }
    
}
