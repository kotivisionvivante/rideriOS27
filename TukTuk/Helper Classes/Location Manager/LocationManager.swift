//
//  LocationManager.swift
//  TukTuk
//
//  Created by Harjot Harry on 2/18/20.
//  Copyright © 2020 TukTuk Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class LocationManagerH: NSObject, CLLocationManagerDelegate {
    
    //MARK:- Variables
    
    var locationManager    = CLLocationManager()
    var isLocationEnable = false
    var currentAddress = String()
    var latitude = Double()
    var longitude = Double()
    
    // MARK: Shared Instance
    class  var sharedInstance: LocationManagerH {
        struct Singleton {
            static let instance = LocationManagerH()
        }
        return Singleton.instance
    }
    //MARK:- Custom Method
    func initLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    //MARK:- Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let dict = ["latitude":userLocation?.coordinate.latitude,"longitude":userLocation?.coordinate.longitude]
        latitude = userLocation?.coordinate.latitude ?? 0.00
        longitude = userLocation?.coordinate.longitude ?? 0.00
        NotificationCenter.default.post(name: Notification.Name("updateLocation"), object: nil, userInfo: dict as [AnyHashable : Any])
        isLocationEnable = true
        getAddressFromLatLonGeo(pdblLatitude: "\(userLocation?.coordinate.latitude ?? 0.00)", withLongitude: "\(userLocation?.coordinate.longitude ?? 0.00)") { (name,locality) in
            let address = "\(name),\(locality)"
            self.currentAddress = address
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        switch status {
        case CLAuthorizationStatus.restricted:
            print("Restricted Access to location")
        case CLAuthorizationStatus.denied:
            print("User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            print("Status not determined")
        default:
            print("Allowed to location Access")
            shouldIAllow = true
        }
        isLocationEnable = false
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        }
    }
    
    func getAddressFromLatLonGeo(pdblLatitude: String, withLongitude pdblLongitude: String,completion: @escaping (String,String) -> Void) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.00
        //21.228124
        let lon: Double = Double("\(pdblLongitude)") ?? 0.00
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)  {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks ?? []
                if pm.count > 0 {
                    let pm = placemarks![0]
                    completion(pm.name ?? "" ,pm.locality ?? "")
                }
        })
        
    }
}

