//
//  CityListCell.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/29.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

class CityListCell: UITableViewCell{
  
  @IBOutlet weak var cityLabel: UILabel!
  
  func addCityName(city: City){
    cityLabel.text = city.cityCN
  }
  
}
