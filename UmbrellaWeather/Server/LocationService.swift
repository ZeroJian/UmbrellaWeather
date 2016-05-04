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
  var parserXML:ParserXML!
  
  static let singleClass = LocationService()
  
  enum LocationState{
    case Loading
    case Result(String)
    case NoService
    case Normal
  }
  
  var afterUpdatedCityAction: (Bool -> Void)?
  
  private(set) var locationState: LocationState = .Normal
  
  private let locationManager = CLLocationManager()
  
    private func startLocation(){
    if CLLocationManager.locationServicesEnabled(){
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      locationManager.startUpdatingLocation()
      updatingLocation = true
      locationState = .Loading
    }else{
      locationState = .NoService
    }
  }
  
//  lazy var locationManager: CLLocationManager = {
//    let locationManager = CLLocationManager()
//    locationManager.delegate = self
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//    return locationManager
//  }()
  var whenInUse = false
  var denied = false

  func beginLocation(){
    let authStatus = CLLocationManager.authorizationStatus()
    if authStatus == .NotDetermined{
      locationManager.requestWhenInUseAuthorization()
    }
    if authStatus == .Denied || authStatus == .Restricted{
      locationState = .NoService
      return
    }
    if whenInUse{
      if updatingLocation{
        stopLocationManager()
      }else{
        startLocation()
      }
    }
  }
  
  func updateingLocation() {
    if whenInUse{
    if updatingLocation{
      stopLocationManager()
    }else{
      startLocation()
    }
    }
  }
  
  private func stopLocationManager(){
    if updatingLocation{
      locationManager.stopUpdatingLocation()
      locationManager.delegate = nil
      parserXML = nil
      updatingLocation = false
    }
  }
  
 
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    switch status {
    case .AuthorizedWhenInUse:
      whenInUse = true
    case .Denied:
      denied = true
    default:
      break
      
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
   guard let newLocation = locations.last else{
    self.locationState = .NoService
      return
    }
    stopLocationManager()
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(newLocation) { (placemarks, error) -> Void in
      var sucess = false
      if error != nil{
        self.locationState = .NoService
      }else if let p = placemarks where !p.isEmpty{
   
        if let locality = p.last?.locality{
          print(locality)
          let city = self.rangeOfCities(locality)
          sucess = true
          self.locationState = .Result(city)
          
          self.stopLocationManager()
        }
      }
      self.afterUpdatedCityAction?(sucess)
    }
  }
  
  private func rangeOfCities(placemark: String) -> String{
    parserXML = ParserXML()
    let cities = parserXML.cities
    for (_ , value) in cities.enumerate(){
      if placemark.rangeOfString(value.cityCN) != nil{
        return  value.cityCN
      }
    }
    return placemark
  }
}