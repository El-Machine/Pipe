//
//  Event_Tests.swift
//  toolburator_Tests
//
//  Created by Alex Kozin on 29.04.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CoreLocation
import CoreMotion
import XCTest

class Expect_T_Tests: XCTestCase {

    func test_Every() throws {
        //Insert 'count' times
        let count = random()

        let e = expectation()
        e.expectedFulfillmentCount = count

        var last: Vector!

        //Wait for 'count' Vectors
        weak var pipe: Pipe!
        pipe = |.every { (vector: Vector) in
            //Is equal?
            if vector == last {
                e.fulfill()
            }
        }

        //Put for 'count' Vectors
        (0..<count).forEach { _ in
            last = Vector.any
            pipe.put(last!)
        }

        waitForExpectations(timeout: .default)

        pipe.close()
        XCTAssertNil(pipe)
    }

    func test_One() throws {
        let e = expectation()

        let vector = Vector.any

        weak var pipe: Pipe!
        pipe = |.one { (vector: Vector) in
            e.fulfill()
        }

        pipe.put(vector)

        waitForExpectations()
        XCTAssertNil(pipe)
    }

    func test_While() throws {

        func put() {
            DispatchQueue.main.async {
                pipe.put(Vector.any)
            }
        }

        let e = expectation()

        weak var pipe: Pipe!
        pipe = |.while { (vector: Vector) in

            if vector.id == 2 {
                e.fulfill()
                return false
            } else {
                put()
                return true
            }

        }

        put()

        waitForExpectations()
        XCTAssertNil(pipe)
    }

    struct Vector: Equatable, Any_ {

        let id: Int

        let x, y, z: Float
        var t: TimeInterval


        static var any: Vector {
            .init(id: .any(in: 0...4), x: .any, y: .any, z: .any, t: .any)
        }
    }

}
