//
//  Departure.swift
//  TestGTT
//
//  Created by Giovanni Coriasco on 31/10/15.
//  Copyright © 2015 Giovanni Coriasco. All rights reserved.
//

import UIKit

class LineDepartures: NSObject {
    private var dictionary: NSDictionary
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    override init() {
        self.dictionary = NSDictionary()
    }
    var name: String {
        get {
            return dictionary["name"] as? String ?? ""
        }
    }
    var longName: String {
        get {
            return dictionary["longName"] as? String ?? ""
        }
    }
    var lineType: String {
        get {
            return dictionary["lineType"] as? String ?? ""
        }
    }
    var departures: [Departure] {
        get {
            if let d = dictionary["departures"] as? NSArray {
                return d.map({
                    if let dictionary = $0 as? NSDictionary {
                        return Departure(dictionary: dictionary)
                    }
                    return Departure()
                })
            }
            return [Departure]()
        }
    }

}
