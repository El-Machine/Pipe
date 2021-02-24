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

import CoreBluetooth

extension CBCharacteristic: Pipable {
    
    @discardableResult
    static func |(from: CBCharacteristic, handler: @escaping ([CBDescriptor])->()) -> CBCharacteristic {
        from.service.peripheral.discoverDescriptors(for: from)
        return from | .once(from|, handler: handler)
    }
    
    @discardableResult
    static func |(from: CBCharacteristic, handler: @escaping (Data)->()) -> CBCharacteristic {
        from.service.peripheral.setNotifyValue(true, for: from)
        return from | .every(from|, handler: handler)
    }
    
}

@discardableResult
func |(from: CBUUID, handler: @escaping (CBCharacteristic)->()) -> CBUUID {
    
    guard let periphiral: CBPeripheral = from.pipe()?.get() else {
        return from
    }
    
    periphiral | { (services: [CBService]) in
        services.forEach {
            
            $0 | { (c: [CBCharacteristic]) in
                let characteristic = c.first {
                    $0.uuid == from
                }
                
                if let characteristic = characteristic {
                    periphiral.setNotifyValue(true, for: characteristic)
                }
            }
            
        }
    }
    
    return from | .every(from.uuidString, handler: handler)
}
