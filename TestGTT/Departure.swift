//
//  Departure.swift
//  TestGTT
//
//  Created by Giovanni Coriasco on 31/10/15.
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

}
