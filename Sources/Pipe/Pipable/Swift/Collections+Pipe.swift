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
//  2022 Alex Kozin
//

import Foundation.NSIndexPath
import StoreKit

//Array
extension Array {
    
    static postfix func |(p: Self) -> Range<Int> {
        0..<p.count
    }
    
}

extension Array where Element: BinaryInteger {
    
    static postfix func |(p: Self) -> Data {
        Data(p as! [UInt8])
    }
    
}

//Range
extension Range where Bound: FixedWidthInteger {
    
    static postfix func |(p: Self) -> Bound {
        .random(in: p)
    }
    
}

extension Range where Bound: BinaryFloatingPoint,
                      Bound.RawSignificand: FixedWidthInteger {
    
    static postfix func |(p: Self) -> Bound {
        .random(in: p)
    }
    
}

extension ClosedRange where Bound: FixedWidthInteger {
    
    static postfix func |(p: Self) -> Bound {
        .random(in: p)
    }
    
}

extension ClosedRange where Bound: BinaryFloatingPoint,
                            Bound.RawSignificand: FixedWidthInteger {
    
    static postfix func |(p: Self) -> Bound {
        .random(in: p)
    }
    
}
