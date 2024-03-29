//
//  ContentView.swift
//  Shared
//
//  Created by Alex Kozin on 29.08.2022.
//


import ARKit
import RealityKit

import Pipe
import SwiftUI

struct ContentView: View {

    var body: some View {
        Text("Hello, Pipe! |").onAppear {


            if #available(iOS 14.3, *) {

                let pipe = .add | { (appCode: ARAppClipCodeAnchor) in
                    print("")
                }

                let view: ARView = pipe.get()
                UIApplication.shared.visibleViewController?.visible

            }

        }
    }

    func codes() {

    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
