//
//  SkipListTests.swift
//  SkipListTests
//
//  Created by Nick on 14/02/2019.
//  Copyright © 2019 Nick. All rights reserved.
//

import XCTest

class SkipListTests: XCTestCase {
    
    func testSearch() {
        var s = SkipList<Int, Int>()
        s[1000] = 1
        XCTAssert(s[1000] == 1)
    }

}
