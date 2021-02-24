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

#if DEBUG
import Foundation

extension Pipe: CustomStringConvertible {
    
    static func all() -> [Pipe] {
        pipes.map {
            $1
        }.reduce([Pipe]()) { (result, candidat) -> [Pipe] in
            let first = result.first {
                $0 === candidat
            }
            
            if first == nil {
                return result + [candidat]
            } else {
                return result
            }
        }
    }
    
    var description: String {
        """
        <Pipe \(String(describing: Unmanaged.passUnretained(self).toOpaque()))>
        """
//        <Pipe \(String(describing: Unmanaged.passUnretained(self).toOpaque()))> piped:
//        \(piped.reduce("") {
//            $0 + String(describing: $1) + "\n"
//        })
    }
    
    static func printLog() {
        print("Total pipes: \n %@ \n", Pipe.all())
    }
    
}
#endif
