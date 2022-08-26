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

import CoreGraphics.CGImage
import CoreImage.CIImage

import Vision.VNRequest

extension VNImageRequestHandler: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {

        let orientation: CGImagePropertyOrientation = pipe.get() ?? .up
        let options: [VNImageOption : Any] = pipe.get() ?? [:]

        let request: Self
        switch piped {
            case let buffer as CMSampleBuffer:
                if #available(iOS 14.0, macOS 11.0, *) {
                    request = Self(cmSampleBuffer: buffer, orientation: orientation, options: options)
                } else {
                    fatalError()
                }

            case let image as CGImage:
                request = Self(cgImage: image, orientation: orientation, options: options)
            case let image as CIImage:
                request = Self(ciImage: image, orientation: orientation, options: options)

            case let data as Data:
                request = Self(data: data, orientation: orientation, options: options)

            case let url as URL:
                request = Self(url: url, orientation: orientation, options: options)

            default:
                fatalError("""
                                🔥 It's yet not possible to construct
                                \(self)
                                from
                                \(String(describing: piped))
                           """)
        }

        return request
    }

}
