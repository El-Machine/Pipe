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

private typealias Ell = CBCentralManager.Ell

extension CBCentralManager: Source {

    struct Ell: Pipable {
        
        var queue: DispatchQueue?
        
        //CBCentralManagerOptionShowPowerAlertKey
        //CBCentralManagerOptionRestoreIdentifierKey
        var manager: [String: Any]?
        
        var services: [CBUUID]?
        
        //CBCentralManagerScanOptionAllowDuplicatesKey = false
        //CBCentralManagerScanOptionSolicitedServiceUUIDsKey
        var scan: [String : Any]?
        
    }
    
    struct Tee: Pipable {
        
        @discardableResult
        static func didConnect(handler: @escaping (CBPeripheral)->()) -> Tee {
            Tee() | .every("didConnect", handler: handler)
        }
        
        @discardableResult
        static func didFailToConnect(handler: @escaping (CBPeripheral, Error)->() ) -> Tee {
            Tee() | .every("didFailToConnect", handler: handler)
        }
        
        @discardableResult
        static func didDisconnectPeripheral(handler: @escaping (CBPeripheral, Error)->() ) -> Tee {
            Tee() | .every("didDisconnectPeripheral", handler: handler)
        }
        
        @discardableResult
        static func connectionEventDidOccur(handler: @escaping (CBConnectionEvent, CBPeripheral)->() ) -> Tee {
            Tee() | .every(handler: handler)
        }
        
        @discardableResult
        static func didUpdateANCSAuthorizationFor(handler: @escaping (CBPeripheral, Error)->() ) -> Tee {
            Tee() | .every("didUpdateANCSAuthorizationFor", handler: handler)
        }
        
        
        // Add expectation for event to manager
        //
        // manager | .didConnect { (object: CBPeripheral) in
        //
        // }
        @discardableResult
        static func | (pipable: CBCentralManager, tee: Tee) -> CBCentralManager {
            pipable.pipe().weld(with: tee)|
        }
        
    }
    
    static func |(from: Pipable?, _: CBCentralManager.Type) -> Self {
        let pipe = Pipe.from(from)
               
        let delegate = pipe.put(Delegate())
        let ell: Ell? = from| 
        
        let source = CBCentralManager(delegate: delegate,
                                     queue: ell?.queue,
                                     options: ell?.manager)
        return pipe.put(source) as! Self
    }
     
}

extension CBCentralManager {
    
    class Delegate: NSObject, CBCentralManagerDelegate, Pipable {
        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            pipe()?.expectations?.come(for: central.state)
        }
        
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
            
            pipe()?.expectations?.come(for: peripheral)
            pipe()?.expectations?.come(for: (peripheral, advertisementData, RSSI))
        }
        
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            pipe()?.expectations?.come(for: peripheral, with: "didConnect")
        }
        
        func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
            pipe()?.expectations?.come(for: peripheral, with: "didFailToConnect", error: error)
        }
        
        func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
            pipe()?.expectations?.come(for: peripheral, with: "didDisconnectPeripheral", error: error)
        }
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            pipe()?.expectations?.come(for: peripheral.services, error: error)
        }
        
    }
    
}

