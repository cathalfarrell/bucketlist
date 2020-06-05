//
//  ContentView.swift
//  BucketList
//
//  Created by Cathal Farrell on 02/06/2020.
//  Copyright © 2020 Cathal Farrell. All rights reserved.
//

import LocalAuthentication
import MapKit
import SwiftUI

struct ContentView: View {

    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [CodableMKPointAnnotation]()

    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false

    @State private var isUnlocked = true

    var body: some View {

            ZStack {
                if isUnlocked {
                    MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                        .edgesIgnoringSafeArea(.all)
                    //Zstack places Circle on top of map in center
                    Circle()
                        .fill(Color.blue)
                        .opacity(0.3)
                        .frame(width: 32, height: 32)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                // create a new location
                                let newLocation = CodableMKPointAnnotation()
                                newLocation.coordinate = self.centerCoordinate
                                newLocation.title = "Example location"
                                self.locations.append(newLocation)
                                self.selectedPlace = newLocation
                                self.showingEditScreen = true
                            }) {
                                Image(systemName: "plus")
                                .padding()// adds padding before adding background
                                .background(Color.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                /* Challenge 1
                                 Our + button is rather hard to tap. Try moving all its modifiers to the image inside the button – what difference does it make, and can you think why?
                                 */
                            }
                            .padding(.trailing, 8)
                            .padding(.bottom, 30)

                        }
                    }
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
            }.alert(isPresented: $showingPlaceDetails) {
                Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                    // edit this place
                    self.showingEditScreen = true
                })
            }
            .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
                if self.selectedPlace != nil {
                    EditView(placemark: self.selectedPlace!)
                }
            }
            .onAppear(perform: loadData) //loads any saved data on launch
    }


    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")

        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }

    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            // MARK: - Strong file encryption using .completeFileProtection
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
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
