//  Copyright (c) 2020-2021 El Machine (http://el-machine.com/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//  2020 El Machine
//

//import XCTest
//
//class Collections_Tests: XCTestCase {
//
//    func testArrayRange() throws {
//        let array = [Bool](repeating: false, count: 42)
//
//        let range: Range<Int> = array|
//        XCTAssertTrue(range.first == 0)
//        XCTAssertTrue(range.last == array.count - 1)
//    }
//
//    func testArrayIndexPath() throws {
//        let array = [Bool](repeating: false, count: 42)
//
//        let paths: [IndexPath] = array|
//        XCTAssertTrue(paths.first?.row == 0)
//        XCTAssertTrue(paths.last?.row == array.count - 1)
//    }
//
//    func testRangeIndexPath() throws {
//        let range = 0..<42
//
//        let paths: [IndexPath] = range|
//        XCTAssertTrue(paths.first?.row == 0)
//        XCTAssertTrue(paths.last?.row == range.last)
//    }
//
//    func testRangeInt() throws {
//        let range = 0..<42
//
//        let randomInt: Int = range|
//        XCTAssertTrue(randomInt >= range.first!)
//        XCTAssertTrue(randomInt <= range.last!)
//    }
//
//}
