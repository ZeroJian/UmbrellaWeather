//
//  WeekWeatherCollectionView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/23.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

class WeekWeatherCollectionView: UICollectionView {

  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    let cellNib = UINib(nibName: "WeekWeatherCell", bundle: nil)
    self.registerNib(cellNib, forCellWithReuseIdentifier: "WeekWeatherCell")
  }
  
}
