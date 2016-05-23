//
//  WeatherView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/23.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

class WeatherView: UIView {

  
  @IBOutlet weak var weatherImage: UIImageView!
  @IBOutlet weak var tmpMaxLabel: UILabel!
  @IBOutlet weak var tmpMinLabel: UILabel!
  @IBOutlet weak var rainPercentLabel: UILabel!
  @IBOutlet weak var schemaLabel: UILabel!
  @IBOutlet weak var progress: UIProgressView!
  @IBOutlet weak var maxLabelConstraint: NSLayoutConstraint!
  @IBOutlet weak var minLabelConstraint: NSLayoutConstraint!
  @IBOutlet weak var percentConstraint: NSLayoutConstraint!
  var loadingImageView: UIImageView!
  var loading = false
  
  var offsetY: CGFloat! {
    didSet {
      if offsetY >= 40 && offsetY <= 140 {
        weatherImage.alpha = 1 - (0.02 * (offsetY - 30))
      } else {
        weatherImage.alpha = 1
      }
    }
  }
  
  
  func updateAndAnimation(weatherResult: WeatherResult){
    animation() 
    schemaLabel.text = weatherResult.state
    weatherImage.imageWithCode(weatherResult.stateCode)
    tmpMaxLabel.text = weatherResult.dayTemMax
    tmpMinLabel.text = weatherResult.dayTmpMin
    if let FloatRain = Float(weatherResult.dayRain){
      let value = FloatRain / 100
      progress.setProgress(value, animated: true)
    }
    rainPercentLabel.text = weatherResult.dayRain + "%"
  }
  
  func loadingAnimated(){
    loadingImageView = UIImageView(image: UIImage(named: "Loading")!)
    loadingImageView.center.x = self.center.x
    loadingImageView.center.y = self.center.y - 50
    loadingImageView.bounds.size.width = self.bounds.size.width / 5
    loadingImageView.bounds.size.height = loadingImageView.bounds.size.width
    self.addSubview(loadingImageView)
    loadingAnimation(loadingImageView)
    loading = true
  }
  
  func loadingFinish(){
      loadingImageView.layer.removeAllAnimations()
      loadingImageView.removeFromSuperview()
      loading = false
  }
  
  func animationBegin(){
    maxLabelConstraint.constant = 25
    minLabelConstraint.constant = 25
    percentConstraint.constant = 10
    weatherImage.hidden = true
    weatherImage.transform = CGAffineTransformMakeScale(0.7, 0.7)
    schemaLabel.text = ""
    tmpMaxLabel.text = ""
    tmpMinLabel.text = ""
    rainPercentLabel.text = ""
  }
  
  private func animation(){
    UIView.animateWithDuration(0.66, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
      self.weatherImage.hidden = false
      self.weatherImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }, completion: nil)
    self.maxLabelConstraint.constant = 5
    UIView.animateWithDuration(0.66, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
      self.layoutIfNeeded()
      }, completion: nil)
    UIView.animateWithDuration(0.66, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
      self.minLabelConstraint.constant = 5
      self.layoutIfNeeded()
      }, completion: nil)
    UIView.animateWithDuration(0.66, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
      self.percentConstraint.constant = 30
      self.layoutIfNeeded()
      }, completion: nil)
  }
}
