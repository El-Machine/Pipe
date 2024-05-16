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

import CoreLocation.CLLocation

extension CLLocationManager: Constructor {
    
    static func | (piped: Any?, type: CLLocationManager.Type) -> Self {
        let pipe = piped.pipe

        let delegate = pipe.put(Delegate())

        let source = Self()
        source.delegate = delegate
        source.desiredAccuracy = pipe.get(for: "CLLocationAccuracy") ?? kCLLocationAccuracyThreeKilometers
        source.distanceFilter = pipe.get(for: "CLLocationDistance") ?? 100
        
        return pipe.put(source)
    }
    
}

extension CLLocationManager {
    
    class Delegate: NSObject, CLLocationManagerDelegate, Pipable {
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let last = locations.last {
                isPiped?.put(last)
            }

            if locations.count > 1 {
                isPiped?.put(locations)
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            isPiped?.put(error)
        }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            isPiped?.put(status)
        }
        
    }
    
}
