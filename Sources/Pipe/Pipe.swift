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

final class Pipe {
    
    //All pipes
    static var pipes = [String: Pipe]()
    
    //Piped objects
    var piped = [String: Any]()
    
    //Expectations of objects in pipe
    private(set) var expectations: Expectations?
    private(set) lazy var expect: Expectations = {
        expectations = Expectations(self)
        return expectations!
    }()
    
    //Get or create
    class func from(_ pipable: Pipable?) -> Pipe {
        pipable?.pipe() ?? Pipe()
    }
    
    //Close
    func close() {
        piped.removeAll()
        
        Pipe.pipes = Pipe.pipes.filter {
            $1 !== self
        }
        
        expectations = nil
    }
    
}

//Put to pipe
extension Pipe {
    
    @discardableResult
    func put<T>(_ object: T) -> T {
        Pipe.pipes[object|] = self
        piped[T.self|] = object
        
        if let sequence = object as? Array<Any> {
            sequence.forEach {
                Pipe.pipes[$0|] = self
            }
        }
        
        return object
    }
    
    @discardableResult
    func put<T>(_ create: ()->(T)) -> T {
        put(create())
    }
    
}

//Get from pipe
extension Pipe {
    
    func get<T>() -> T? {
        piped[String(describing: T.self)] as? T
    }
    
    func getOrCreate<T>(_ create: ()->(T)) -> T {
        get() ?? put(create())
    }
    
    func getOrCreate<T>(_ object: T) -> T {
        get() ?? put(object)
    }
    
}

//Welding
extension Pipe {
    
    @discardableResult
    func weld<T: Pipable>(with: T) -> T {
        guard let pipe = with.pipe() else {
            return self.put(with)
        }
        
        expectations?.merge(with: pipe.expectations)
        
        pipe.piped.forEach {
            put($0)
        }
        
        pipe.close()
        
        return with
    }
    
}
