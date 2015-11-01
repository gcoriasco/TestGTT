//
//  GTT.swift
//  TestGTT
//
//  Created by Giovanni Coriasco on 31/10/15.
//  Copyright © 2015 Giovanni Coriasco. All rights reserved.
//

import UIKit

class GTT: NSObject {
    private static let baseUrl = "http://www.5t.torino.it/ws2.1/rest"
    private static var allStopsUrl: String {
        get {
            return "\(baseUrl)/stops/all"
        }
    }
    private static func departuresUrlWithStopId(stopId: String) -> String {
        return "\(baseUrl)/stops/\(stopId)/departures"
    }
    static let sharedInstance = GTT()
    private override init() {}
    
    private func fetchUrl(urlString: String) -> AnyObject! {
        if let url = NSURL(string: urlString) {
            if let data = NSData(contentsOfURL: url) {
                //NSLog("Fetched data from url '\(urlString)':\n\(String(data: data, encoding: NSUTF8StringEncoding)!)")
                return try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            } else {
                NSLog("Failed to fetch url '\(urlString)'")
            }
        }
        return nil
    }
    var allStops: [Stop] {
        get {
            if let json = fetchUrl(GTT.allStopsUrl) as? NSDictionary {
                if let jsonStops = json["stops"] as? NSArray {
                    return jsonStops.map({
                        if let dictionary = $0 as? NSDictionary {
                            return Stop(dictionary: dictionary)
                        }
                        return Stop()
                    })
                }
            }
            return [Stop]()
        }
    }
    func departuresForStopId(stopId: String) -> [LineDepartures] {
        if let jsonStops = fetchUrl(GTT.departuresUrlWithStopId(stopId)) as? NSArray {
            return jsonStops.map({
                if let dictionary = $0 as? NSDictionary {
                    return LineDepartures(dictionary: dictionary)
                }
                return LineDepartures()
            })
        }
        return [LineDepartures]()
    }
}
