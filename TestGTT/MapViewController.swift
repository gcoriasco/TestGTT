//
//  ViewController.swift
//  TestGTT
//
//  Created by Giovanni Coriasco on 30/10/15.
//  Copyright © 2015 Giovanni Coriasco. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var waitingView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    private let maxAnnotations = 50
    private let initialUserLocationSpan = 0.008
    private let annotationViewReuseId = "GTTPMapAnnotationViewIdentifier"
    //private let updateQueue = dispatch_queue_create("MapUpdateQueue", nil)
    private var locationManager = CLLocationManager()
    private var allStops: [Stop]!
    private var didCenterOnUserLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        checkLocationAuthorization(CLLocationManager.authorizationStatus())
        
        mapView.delegate = self
        // Turin: latitude +45.053951, longitude +7.660507, latitude delta +0.147244, longitude delta +0.132337
        let mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.053951, longitude: 7.660507), span: MKCoordinateSpan(latitudeDelta: 0.147244, longitudeDelta: 0.132337))
        mapView.setRegion(mapRegion, animated: true)
        //mapView.addAnnotation(Stop(coordinate: CLLocationCoordinate2D(latitude: 45.053951, longitude: 7.660507), title: "Center", subtitle: "Turin center"))
        mapView.showsUserLocation = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            NSLog("fetching allStops")
            self.allStops = GTT.sharedInstance.allStops
            NSLog("allStops returned \(self.allStops.count) elements")
            self.updateVisibleStops()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateVisibleStops() {
        //dispatch_async(updateQueue) {
            if self.allStops == nil {
                return
            }
            
            /*dispatch_async(dispatch_get_main_queue()) {
                self.waitingView.hidden = false
            }*/
            
            // Find which stops can be visible and are already on the map
            //NSLog("Filtering toAdd")
            let toShow = self.allStops.filter({ MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate($0.coordinate)) })
            //NSLog("Filtered toAdd: \(toShow.count)")
            
            // Find which stops are currently on the map but no more visible
            //NSLog("Filtering toRemove")
            let toHide = self.mapView.annotations.filter({ !MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate($0.coordinate)) })
            //NSLog("Filtered toRemove: \(toHide.count)")
            
            if toShow.count <= self.maxAnnotations {
                // Display stops on map only if less than 'maxAnnotations'
                dispatch_async(dispatch_get_main_queue()) {
                    //NSLog("Updating annotations")
                    self.mapView.addAnnotations(toShow)
                    self.mapView.removeAnnotations(toHide)
                    //NSLog("Updated annotations: \(self.mapView.annotations.count)")
                }
            } else {
                // Otherwize remove every stop
                dispatch_async(dispatch_get_main_queue()) {
                    //NSLog("Removing annotations: \(self.mapView.annotations.count)")
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    //NSLog("Removed annotations")
                }
            }
            
            /*dispatch_async(dispatch_get_main_queue()) {
                self.waitingView.hidden = true
            }*/
        //}
    }

    func checkLocationAuthorization(authorizatonStatus: CLAuthorizationStatus) {
        if authorizatonStatus == CLAuthorizationStatus.Restricted || authorizatonStatus == CLAuthorizationStatus.Denied {
            NSLog("Location not authorized")
            return
        } else if authorizatonStatus == CLAuthorizationStatus.NotDetermined {
            NSLog("Asking user for location authorization")
            locationManager.requestWhenInUseAuthorization()
        } else {
            NSLog("Location authorized with \(authorizatonStatus.rawValue)")
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.distanceFilter = 5.0
            locationManager.startUpdatingLocation()
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if location != nil {
            //mapView.setCenterCoordinate(location!.coordinate, animated: true)
            //NSLog("latitude %+.6f, longitude %+.6f", location!.coordinate.latitude, location!.coordinate.longitude)
            if !didCenterOnUserLocation {
                dispatch_async(dispatch_get_main_queue()) {
                    self.didCenterOnUserLocation = true
                    let mapRegion = MKCoordinateRegion(center: location!.coordinate, span: MKCoordinateSpan(latitudeDelta: self.initialUserLocationSpan, longitudeDelta: self.initialUserLocationSpan))
                    self.mapView.setRegion(mapRegion, animated: true)
                    self.updateVisibleStops()
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NSLog("didChangeAuthorizationStatus: \(status.rawValue)")
        checkLocationAuthorization(status)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
    }
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.updateVisibleStops()
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationViewReuseId) as? StopView
        if (view == nil) {
            view = StopView(annotation: annotation, reuseIdentifier: annotationViewReuseId)
        }
        return view
    }
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let stop = view.annotation as? Stop {
            NSLog("\(stop.name) tapped: \(stop.lines)")
        }
    }
}

