//
//  Location.swift
//  UmberellaWeather
//
//  Created by ZeroJianMBP on 16/1/4.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit
import CoreLocation



class LocationService: NSObject,CLLocationManagerDelegate{
  
  
  var updatingLocation = false
  var parserXML:ParserXML?
   let geocoder = CLGeocoder()
  
  static let sharedManager = LocationService()
  
  enum LocationStatus{
    case Loading
    case Result(String)
    case Normal
  }
  
  class func startLocation() {
    if CLLocationManager.locationServicesEnabled() {
      self.sharedManager.locationManager.startUpdatingLocation()
    }
  }
  
  
  var afterUpdatedCityAction: (Bool -> Void)?
  
  private(set) var locationStatus: LocationStatus = .Normal
  

  
  lazy var locationManager: CLLocationManager = {
    let locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    return locationManager
  }()
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    
    if status == .Denied {
      NSNotificationCenter.defaultCenter().postNotificationName("Location_Denied", object: nil)
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
   guard let newLocation = locations.last else{
      return
    }
    locationManager.stopUpdatingLocation()

    
    geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) -> Void in
      var sucess = false
      self.locationStatus = .Loading
      if error != nil{
        
      }else if let p = placemarks where !p.isEmpty{
   
        if let locality = p.last?.locality{
          self.parserXML = ParserXML()
          let cityName = self.parserXML!.rangeOfLocation(locality)
          sucess = true
          self.locationStatus = .Result(cityName)
          self.parserXML = nil
        }
      }
      self.afterUpdatedCityAction?(sucess)
    }
  }
}