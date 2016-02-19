//
//  AppDelegate.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/7.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var dataModel = DataModel()
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    let controller = self.window?.rootViewController as! HomeViewController
    controller.dataModel = dataModel
   
   UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(NSTimeInterval(3600 * 12))
  
    return true
  }
  
  func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    let serviceResult = ServiceResult()
    serviceResult.fetchDailyResults(dataModel.currentCity) { [weak self] dailyResults  in
      self?.dataModel.dailyResults = dailyResults
      self?.dataModel.saveData()
      completionHandler(.NewData)
    }
  }

  func applicationWillResignActive(application: UIApplication) {
  }

  func applicationDidEnterBackground(application: UIApplication) {
    saveData()
  }

  func applicationWillEnterForeground(application: UIApplication) {
    let serviceResult = ServiceResult()
    serviceResult.fetchDailyResults(dataModel.currentCity) { [weak self] dailyResults  in
      self?.dataModel.dailyResults = dailyResults
    }
  }

  func applicationDidBecomeActive(application: UIApplication) {
    
  }

  func applicationWillTerminate(application: UIApplication) {
    saveData()
  }
  
  func saveData(){
    dataModel.saveData()
  }
  
}

