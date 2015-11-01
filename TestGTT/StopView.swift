//
//  StopView.swift
//  TestGTT
//
//  Created by Giovanni Coriasco on 01/11/15.
//  Copyright © 2015 Giovanni Coriasco. All rights reserved.
//

import UIKit
import MapKit

class StopView: MKPinAnnotationView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        let button = UIButton(type: UIButtonType.DetailDisclosure)
        rightCalloutAccessoryView = button
        
        
        let label = UILabel(frame: CGRectMake(0, 0, 80, frame.height))
        label.textAlignment = NSTextAlignment.Center
        leftCalloutAccessoryView = label
        
        canShowCallout = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            if let stop = annotation as? Stop {
                switch stop.type {
                case "BUS":
                    pinTintColor = MKPinAnnotationView.greenPinColor()
                case "METRO":
                    pinTintColor = MKPinAnnotationView.redPinColor()
                case "TRENO":
                    pinTintColor = MKPinAnnotationView.purplePinColor()
                default:
                    pinTintColor = UIColor.blackColor()
                }
                if let label = leftCalloutAccessoryView as? UILabel {
                    label.text = stop.type
                    label.backgroundColor = pinTintColor
                }
            }
        }
    }
}
