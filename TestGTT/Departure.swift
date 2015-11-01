//
//  Departure.swift
//  TestGTT
//
//  Created by Giovanni Coriasco on 01/11/15.
//  Copyright © 2015 Giovanni Coriasco. All rights reserved.
//

import UIKit

class Departure: NSObject {
    private var dictionary: NSDictionary
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    override init() {
        self.dictionary = NSDictionary()
    }
    var time: String {
        get {
            return dictionary["time"] as? String ?? ""
        }
    }
    var rt: Bool {
        get {
            return dictionary["rt"] as? Bool ?? false
        }
    }
}
