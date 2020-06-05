//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Cathal Farrell on 04/06/2020.
//  Copyright © 2020 Cathal Farrell. All rights reserved.
//

import MapKit

// MARK:- Extension to wrap optionals - because MKPointAnnotation uses optional strings for title and subtitle,
// and SwiftUI doesn’t let us bind optionals to text fields.

extension MKPointAnnotation: ObservableObject {

    public var wrappedTitle: String {
        get {
            return self.title ?? "Unknown value"
        }
        set {
            self.title = newValue
        }
    }

    public var wrappedSubtitle: String {
        get {
            return self.subtitle ?? "Unknown value"
        }
        set {
            self.subtitle = newValue
        }
    }
}

