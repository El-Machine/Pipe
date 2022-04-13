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

import CoreBluetooth.CBPeripheral

extension CBPeripheral: Expectable {

    static func produce<T>(with: Any?, on pipe: Pipe, expecting: Event<T>) {        
        let source = with as? CBCentralManager ?? pipe.get()
        source.retrievePeripherals(withIdentifiers: [])
        print(source.state.rawValue)
        source | .while { (status: CBManagerState) -> Bool in
            guard status == .poweredOn else {
                return true
            }
            
            source.scanForPeripherals(withServices: pipe.get(),
                                      options: pipe.get(for: "CBCentralManagerScanOptions"))
            
            return false
        }
    }
    
}

extension CBPeripheral {
    
    class Delegate: NSObject, CBPeripheralDelegate, Pipable {
        
        func peripheral(_ peripheral: CBPeripheral,
                        didDiscoverServices error: Error?) {
            isPiped?.put(peripheral.services)
            //, error: error)
        }
        
        func peripheral(_ peripheral: CBPeripheral,
                        didDiscoverCharacteristicsFor service: CBService,
                        error: Error?) {
            isPiped?.put(service.characteristics, key: service.uuid.uuidString)
            //, error: error)
        }
        
        func peripheral(_ peripheral: CBPeripheral,
                        didUpdateValueFor characteristic: CBCharacteristic,
                        error: Error?) {
            isPiped?.put(characteristic, key: characteristic.uuid.uuidString)
            //, error: error)
        }
        
        func peripheral(_ peripheral: CBPeripheral,
                        didDiscoverDescriptorsFor characteristic: CBCharacteristic,
                        error: Error?) {
            isPiped?.put(characteristic.descriptors,
                         key: characteristic.uuid.uuidString)
        }
        
    }
    
}
