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
//import CoreMotion
//
//class CoreMotion_Tests: XCTestCase {
//
//    func testPedometerEvent() {
//        let e = expectation(description: "testPedometerEvent")
//
//        |{ (event: CMPedometerEvent) in
//            e.fulfill()
//        }
//
//        waitForExpectations(timeout: 3)
//        XCTAssertTrue(e.assertForOverFulfill)
//    }
//
//    func testPedometerData() {
//        let e = expectation(description: "PedometerData")
//
//        |{ (data: CMPedometerData) in
//            e.fulfill()
//        }
//
//        waitForExpectations(timeout: 20)
//        XCTAssertTrue(e.assertForOverFulfill)
//    }
//
//    func testPedometerDataAndEvent() {
//        let e = expectation(description: "PedometerDataAndEvent")
//        e.expectedFulfillmentCount = 2
//
//        |{ (event: CMPedometerEvent) in
//            e.fulfill()
//        } | { (data: CMPedometerData) in
//            e.fulfill()
//        }
//
//        waitForExpectations(timeout: 20)
//        XCTAssertTrue(e.assertForOverFulfill)
//    }
//
//}
