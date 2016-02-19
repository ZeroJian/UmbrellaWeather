//
//  Citys.swift
//  UmberellaWeather
//
//  Created by ZeroJianMBP on 15/12/25.
//  Copyright © 2015年 ZeroJian. All rights reserved.
//

import Foundation

class City: NSObject,NSCoding{
  var cityCN = ""

  override init(){
    super.init()
  }

  
  required init?(coder aDecoder: NSCoder) {
    cityCN = aDecoder.decodeObjectForKey("CityCN") as! String
    super.init()
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(cityCN, forKey: "CityCN")
  }
  
}