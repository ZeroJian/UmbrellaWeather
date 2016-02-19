//
//  UIImageView+WeatherImage.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/25.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

extension UIImageView{
  func imageWithCode(code: Int){
    if code == 100{
      self.image = UIImage(named: "Sun")
    }else if code >= 101 && code <= 213{
      self.image = UIImage(named: "Cloudy")
    }else if code >= 300 && code <= 313{
      self.image = UIImage(named: "Rain")
    }else if code >= 400 && code <= 407{
      self.image = UIImage(named: "Snow")
    }else if code >= 500 && code <= 504{
      self.image = UIImage(named: "Fog")
    }else{
      self.image = UIImage(named: "Cloudy")
    }
  }
  
  func imageWithResolution(){
    let screenheight = UIScreen.mainScreen().bounds.size.height
    let scale = UIScreen.mainScreen().scale
    let heightRes = screenheight * scale
    switch heightRes{
    case 960.0:
      self.image = UIImage(named: "Launch4")
    case 1136.0:
      self.image = UIImage(named: "Launch5")
    default:
      self.image = UIImage(named: "Launch")
    }
  }
}