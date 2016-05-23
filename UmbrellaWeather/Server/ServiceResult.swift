//
//  ServiceResult.swift
//  UmberellaWeather
//
//  Created by ZeroJianMBP on 15/12/21.
//  Copyright © 2015年 ZeroJian. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias ResultComplete = (Bool) -> Void

class ServiceResult {
  
  enum State{
    case Loading
    case NoRequest
    case NonsupportCity
    case NoYet
    case Results(WeatherResult)
  }
  
 
  private(set) var state: State = .NoYet
  private var dataTask: NSURLSessionDataTask? = nil
  
  func performResult(cityName: String,completion: ResultComplete){
    if !cityName.isEmpty{
      
      dataTask?.cancel()
      state = .Loading
      
    let url = citySearchText(cityName)
    let session = NSURLSession.sharedSession()
    dataTask = session.dataTaskWithURL(url) { (data, response, error) -> Void in
      var success = false
      if error != nil && error?.code == -999{
        print(error)
        return
      }
      if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 ,let data = data{
        success = true
        let dictionary = self.parseJSON(data)
        let weatherResult = self.parseDictionary(dictionary)
        if weatherResult.ServiceStatus == "no more requests"{
          self.state = .NoRequest
        }else if weatherResult.ServiceStatus == "unknown city"{
          self.state = .NonsupportCity
        }else{
        self.state = .Results(weatherResult)
        }
        
      }
      dispatch_async(dispatch_get_main_queue(), {
        completion(success)
      })
    }
    dataTask?.resume()
    }
  }
  
  func fetchDailyResults(cityName: String,completion: ([DailyResult] -> Void)?){
    
    if !cityName.isEmpty{
      
      let url = citySearchText(cityName)
      let session = NSURLSession.sharedSession()
      let dateTask = session.dataTaskWithURL(url) { (data, response, error)
        in
        if error != nil{
          return
        }
        if let data = data{
          let dictionary = self.parseJSON(data)
          let dailyResults =  self.parseWithDairyResults(dictionary)
          completion?(dailyResults)
        }
      }
      dateTask.resume()
    }
  }
  
  
  private func citySearchText(searchText: String) -> NSURL{
    
    //api 每天免费请求次数3000,如果超过请求次数请自行注册
    //和风天气网址: http://www.heweather.com
    
    let apiKeyTest = "cf386feb168149f4a45eb87d4f4b647f"
    
    let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    let urlString = String(format: "https://api.heweather.com/x3/weather?city=%@&key="+apiKeyTest,escapedSearchText)
    let url = NSURL(string: urlString)
    return url!
  }
  
  private func parseJSON(data: NSData) -> JSON{
    return JSON(data: data)
  }
  
  private func parseDictionary(dictionary: JSON) -> WeatherResult{
    let weatherResult = WeatherResult()
    let json = dictionary["HeWeather data service 3.0"][0]
    if let ServiceState = json["status"].string{
      weatherResult.ServiceStatus = ServiceState
    }
    
    if let jsonCity = json["basic"]["city"].string{
      weatherResult.city = jsonCity
    }
    if let state = json["now"]["cond"]["txt"].string{
      weatherResult.state = state
    }
    if let stateCode = json["now"]["cond"]["code"].string{
      weatherResult.stateCode = Int(stateCode)!
    }
  
    let dailyArrays = json["daily_forecast"]
    let dailyDayTmp = dailyArrays[0]["tmp"]
    if let pop = dailyArrays[0]["pop"].string{
      weatherResult.dayRain = pop
    }
    if let dayTemMax = dailyDayTmp["max"].string{
      weatherResult.dayTemMax = dayTemMax + "˚"
    }
    if let dayTmpMin = dailyDayTmp["min"].string{
    weatherResult.dayTmpMin = dayTmpMin + "˚"
    }
    
    for (_,subJson):(String, JSON) in json["daily_forecast"]{
      let dailyResult = DailyResult()
      
      if let dates = subJson["date"].string{
        dailyResult.dailyDate = dates
      }
      if let pop = subJson["pop"].string{
        dailyResult.dailyPop = Int(pop)!
      }
      if let tmpsMax = subJson["tmp"]["max"].string{
        dailyResult.dailyTmpMax = tmpsMax + "˚"
      }
      if let tmpsMin = subJson["tmp"]["min"].string{
        dailyResult.dailyTmpMin = tmpsMin + "˚"
      }
      if let conds = subJson["cond"]["txt_d"].string{
        dailyResult.dailyState = conds
      }
      if let stateCode = subJson["cond"]["code_d"].string{
        dailyResult.dailyStateCode = Int(stateCode)!
      }
      weatherResult.dailyResults.append(dailyResult)
    }
    return weatherResult
  }
  
  private func parseWithDairyResults(dictionary: JSON) -> [DailyResult]{
    var dailyResults = [DailyResult]()
    let json = dictionary["HeWeather data service 3.0"][0]
    for (_,subJson):(String, JSON) in json["daily_forecast"]{
      let dailyResult = DailyResult()
      if let dates = subJson["date"].string{
        dailyResult.dailyDate = dates
      }
      if let pop = subJson["pop"].string{
        dailyResult.dailyPop = Int(pop)!
      }
      if let tmpsMax = subJson["tmp"]["max"].string{
        dailyResult.dailyTmpMax = tmpsMax + "˚"
      }
      if let tmpsMin = subJson["tmp"]["min"].string{
        dailyResult.dailyTmpMin = tmpsMin + "˚"
      }
      if let conds = subJson["cond"]["txt_d"].string{
        dailyResult.dailyState = conds
      }
      if let stateCode = subJson["cond"]["code_d"].string{
        dailyResult.dailyStateCode = Int(stateCode)!
      }
      dailyResults.append(dailyResult)
    }
    return dailyResults
  }

}
  
