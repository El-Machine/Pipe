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

postfix operator |
prefix operator |

protocol Pipable {

    func pipe() -> Pipe
    func pipe() -> Pipe?
    
    var debugPipe: Pipe? {get}

}

extension Pipable {
    
    var debugPipe: Pipe? {
        pipe()
    }
    
    func pipe() -> Pipe {
        pipe() ?? {
            let pipe = Pipe()
            pipe.put(self)

            return pipe
        }()
    }
    
    func pipe() -> Pipe? {
        Pipe.pipes[self|]
    }
    
}

//Close
prefix func | (piped: Pipable) {
    piped.pipe()?.close()
}

//Weld two pipes
func |<R: Pipable>(left: Pipable?, right: R) -> R {
    left?.pipe()?.weld(with: right) ?? right
}

//From pipe
postfix func |<T> (pipable: Pipable?) -> T? {
    (pipable as? T) ?? pipable?.pipe()?.get()
}

//Force unwrap
//postfix func |!<T> (pipable: Pipable) -> T {
//    (pipable as? T) ?? pipable.pipe().get()!
//}

//String from Any
postfix func | (object: Any) -> String {
    if let arg = object as? CVarArg {
        return String(format: "%p", arg)
    } else {
        return String(describing: object)
    }
}

//Error
@discardableResult
func |<T: Pipable> (pipable: T, handler: @escaping (Error)->()) -> T {
    pipable | .every(exclusive: true, handler: handler)
}
