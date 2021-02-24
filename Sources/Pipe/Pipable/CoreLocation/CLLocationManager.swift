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

import CoreLocation.CLLocation

extension CLLocationManager: Source {

    struct Ell {
        
        //kCLLocationAccuracyBestForNavigation
        //kCLLocationAccuracyBest
        //kCLLocationAccuracyNearestTenMeters
        //kCLLocationAccuracyHundredMeters
        //kCLLocationAccuracyKilometer
        //kCLLocationAccuracyThreeKilometers
        //
        //@default
        //kCLLocationAccuracyThreeKilometers
        let desiredAccuracy: CLLocationAccuracy?
        
        //@default
        //100 m
        var distanceFilter: CLLocationDistance?
        
    }
    
    static func |(from: Pipable?, _: CLLocationManager.Type) -> Self {
        let pipe = Pipe.from(from)
        
        let source = CLLocationManager()
        source.delegate = pipe.put(Delegate())
        
        let ell: Ell? = from|
        source.desiredAccuracy = ell?.desiredAccuracy ?? kCLLocationAccuracyThreeKilometers
        source.distanceFilter = ell?.distanceFilter ?? 100
        
        return pipe.put(source) as! Self
    }
    
}

extension CLLocationManager {
    
    class Delegate: NSObject, CLLocationManagerDelegate, Pipable {
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let last = locations.last {
                pipe()?.expectations?.come(for: last)
            }
            
            pipe()?.expectations?.come(for: locations)
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            pipe()?.expectations?.come(for: nil as CLLocation?, error: error)
        }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            pipe()?.expectations?.come(for: status)
        }
        
    }
    
}
