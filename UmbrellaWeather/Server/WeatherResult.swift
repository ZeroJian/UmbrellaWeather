//
//  Result.swift
//  Umbrella Weather
//
//  Created by ZeroJianMBP on 15/12/16.
//  Copyright © 2015年 ZeroJian. All rights reserved.
//

import Foundation

class WeatherResult {
  var city = ""
  var state = ""
  var dayRain = ""
  var dayTemMax = ""
  var dayTmpMin = ""
  var stateCode = 0
  var dailyResults = [DailyResult]()
  var ServiceStatus = ""
}