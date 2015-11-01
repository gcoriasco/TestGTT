//
//  BusStop.swift
//  TestGTT
//
//  Created by Giovanni Coriasco on 30/10/15.
//  Copyright © 2015 Giovanni Coriasco. All rights reserved.
//

import UIKit
import MapKit

class Stop: NSObject, MKAnnotation {
    private var dictionary: NSDictionary
    private func degreesFromKey(key: String) -> Double {
        if let degreesString = dictionary[key] as? String {
            if let degrees = Double(degreesString) {
                return degrees
            }
        }
        return 0.0
    }
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: degreesFromKey("lat"), longitude: degreesFromKey("lng"))
        }
    }
    var title: String? {
        get {
            return "\(name)"
        }
    }
    var subtitle: String? {
        get {
            return "\(lines)"
        }
    }
    var id: String {
        get {
            return dictionary["id"] as? String ?? ""
        }
    }
    var name: String {
        get {
            return dictionary["name"] as? String ?? ""
        }
    }
    var type: String {
        get {
            return dictionary["type"] as? String ?? ""
        }
    }
    var location: String {
        get {
            return dictionary["location"] as? String ?? ""
        }
    }
    var lines: String {
        get {
            return dictionary["lines"] as? String ?? ""
        }
    }
    var placeName: String {
        get {
            return dictionary["placeName"] as? String ?? ""
        }
    }
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    override init() {
        self.dictionary = NSDictionary()
    }
}
