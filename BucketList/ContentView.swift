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
    @State private var authenticationFailed = false
    @State private var errorString = ""

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
        .alert(isPresented: $authenticationFailed) {
            Alert(title: Text("Authentication Required"), message: Text(errorString), dismissButton: .default(Text("OK")))
        }
    }

    /* Challenge 3 -
     Our app silently fails when errors occur during biometric authentication. Add code to show those errors in an alert, but be careful: you can only add one alert() modifier to each view.
     */

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
                        self.errorString = "Failed to authenticate. Please try again."
                        self.authenticationFailed = true
                    }
                }
            }
        } else {
            // no biometrics
            self.errorString = "No biometrics found on device. This app requires biometric authetication for security purposes."
            self.authenticationFailed = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
