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

extension CBPeripheral: FromSource {
    
    typealias From = CBCentralManager
    typealias Ell = CBCentralManager.Ell

    static func |(from: Pipable?, _: CBPeripheral.Type) -> CBCentralManager {
        let piped: CBCentralManager = from|
        
        //Wait for state
        piped | .once { (state: CBManagerState) in
            guard state == .poweredOn else {
                return
            }
            
            let ell: CBPeripheral.Ell? = from|
            piped.scanForPeripherals(withServices: ell?.services,
                                    options: ell?.scan)
        }
        
        return piped
    }
    
    @discardableResult
    static func |(piped: CBPeripheral, handler: @escaping ([CBService])->()) -> CBPeripheral {
        piped.delegate = piped.pipe().put(Delegate())
        piped.discoverServices(nil)
        
        return piped | .once(handler)
    }
    
}


extension CBPeripheral {
    
    class Delegate: CreatableObject, CBPeripheralDelegate {
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            pipe()?.expectations?.come(for: peripheral.services, error: error)   
        }
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            pipe()?.expectations?.come(for: service.characteristics, with: service|, error: error)
        }
        
        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            pipe()?.expectations?.come(for: characteristic, with: characteristic.uuid.uuidString, error: error)
        }
        
        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
            
        }
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
            pipe()?.expectations?.come(for: characteristic.descriptors, with: characteristic|, error: error)
        }
        
    }
    
}

#if targetEnvironment(simulator)

extension CBPeripheral {
    
    static var mock: CBPeripheral {
        let mock = Mock()
        mock.addObserver(mock, forKeyPath: "delegate", options: .new, context: nil)
        
        return mock
    }
    
    class Mock: CBPeripheral {
        
        fileprivate init(_ mock: Mock? = nil) {
        }
        
    }
    
}

#endif
