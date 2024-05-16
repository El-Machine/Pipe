//  Copyright © 2020-2022 El Machine 🤖
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
//

import CoreMotion.CMPedometer

extension CMPedometerData: Expectable, Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        let source = with as? CMPedometer ?? pipe.get()
        source.startUpdates(from: Date()) { (data, error) in
            if let error = error {
                pipe.put(error)
                return
            }

            pipe.put(data!)
        }

        expect.cleaner = {
            source.stopUpdates()
        }
    }
    
}

#if !os(macOS)
extension CMPedometerEvent: Expectable, Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        let source = with as? CMPedometer ?? pipe.get()
        source.startEventUpdates { (update, error) in            
            if let error = error {
                pipe.put(error)
                return
            }

            pipe.put(update!)
        }

        expect.cleaner = {
            source.stopEventUpdates()
        }
    }

}
#endif
