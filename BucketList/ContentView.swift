//
//  ContentView.swift
//  BucketList
//
//  Created by Cathal Farrell on 02/06/2020.
//  Copyright © 2020 Cathal Farrell. All rights reserved.
//

import LocalAuthentication
import SwiftUI

struct ContentView: View {

    @State private var isUnlocked = false

    var body: some View {
            ZStack {
                if isUnlocked {
                    /* Challenge 2
                        Having a complex if condition in the middle of ContentView isn’t easy to read – can you rewrite it so that the MapView, Circle, and Button are part of their own view? This might take more work than you think!
                     */
                    MapScreenView()
                }
                else {
                    Button("Unlock Places") {
                        self.authenticate()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
            }
    }

    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            // Reason taken from info.pist in case of FaceID
            // and from here if TouchID
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        // error
                    }
                }
            }
        } else {
            // no biometrics
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
