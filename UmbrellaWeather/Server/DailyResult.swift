//
//  ArrayWeatherResult.swift
//  Umbrella Weather
//
//  Created by ZeroJianMBP on 15/12/17.
//  Copyright © 2015年 ZeroJian. All rights reserved.
//

import Foundation

class DailyResult: NSObject,NSCoding{
  var dailyTmpMax = ""
  var dailyTmpMin = ""
  var dailyState = ""
  var dailyDate = ""
  var dailyPop = 0
  var dailyStateCode = 0
  
  
  override init() {
    super.init()
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    dailyTmpMax = aDecoder.decodeObjectForKey("DailyTmpMax") as! String
    dailyTmpMin = aDecoder.decodeObjectForKey("DailyTmpMin") as! String
    dailyState = aDecoder.decodeObjectForKey("DailyState") as! String
    dailyDate = aDecoder.decodeObjectForKey("DailyDate") as! String
    dailyPop = aDecoder.decodeIntegerForKey("DailyPop")
    dailyStateCode = aDecoder.decodeIntegerForKey("DailyStateCode")
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(dailyTmpMax, forKey: "DailyTmpMax")
    aCoder.encodeObject(dailyTmpMin, forKey: "DailyTmpMin")
    aCoder.encodeObject(dailyState, forKey: "DailyState")
    aCoder.encodeObject(dailyDate, forKey: "DailyDate")
    aCoder.encodeInteger(dailyPop, forKey: "DailyPop")
    aCoder.encodeInteger(dailyStateCode, forKey: "DailyStateCode")
  }
}