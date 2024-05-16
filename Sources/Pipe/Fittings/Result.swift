//  Copyright © 2020-2022 Alex Kozin
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
//  2022
//

import Foundation

/**
 Add error handler
 - Parameters:
 - handler: Will be invoked only after error
 */
func | (piped: Pipable, handler: @escaping (Error)->()) {
    piped.pipe.expectations["Error"] = [
        Event.every(handler: handler)
    ]
}

/**
 Add success and error handler
 - Parameters:
 - handler: Will be invoked after success and error
 */
func | (piped: Pipable, handler: @escaping (Error?)->()) {
    //TODO: Rewrite "Error" expectations
    let pipe = piped.pipe
    pipe.expectations["Result<Int, Error>"] = [
        Event.every { (result: Result<Int,Error>) in
            switch result {
                case .success(_):
                    handler(nil)
                case .failure(let failure):
                    handler(failure)
            }
        }
    ]
    pipe.expectations["Error"] = [
        Event.every(handler: handler)
    ]
}

extension Result: Producer {

    static func produce<T>(with: Any?, on pipe: Pipe, expecting: Event<T>) {
        //Sometimes we should just wait
    }

}
