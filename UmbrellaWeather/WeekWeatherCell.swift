//
//  WeekWeatherCell.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/21.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

class WeekWeatherCell: UICollectionViewCell{
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var weatherImage: UIImageView!
  @IBOutlet weak var tmpMaxLabel: UILabel!
  @IBOutlet weak var tmpMinLabel: UILabel!
  @IBOutlet weak var rainPercentLabel: UILabel!
  @IBOutlet weak var schemaLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configureForDailyResult(dailyResult: DailyResult){
    
    dateLabel.text = dailyResult.dailyDate
    schemaLabel.text = dailyResult.dailyState
    tmpMaxLabel.text = dailyResult.dailyTmpMax + " /"
    tmpMinLabel.text = dailyResult.dailyTmpMin
    rainPercentLabel.text =
      "\(dailyResult.dailyPop)" + "%"
    weatherImage.imageWithCode(dailyResult.dailyStateCode)
  }

}
