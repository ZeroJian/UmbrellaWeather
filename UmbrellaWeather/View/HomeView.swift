//
//  HomeView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/5/4.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

protocol HomeViewDelegate: class {
  func HomeViewDidScroll(view: HomeView,offsety: CGFloat)
  func HomeViewEndDragging(view: HomeView,offsety: CGFloat,showTimePicker: Bool)
}

class HomeView: UIView {
  
  @IBOutlet weak var scorllView: MainScrollView! {
    didSet {
      scorllView.delegate = self
    }
  }
  
  @IBOutlet weak var headView: HeadView!
  
  weak var delegate: HomeViewDelegate?
  
  var showTimePicker: Bool!
  
  var shouldRemind: Bool!
  
  func remindStatus(status: Bool) {
    scorllView.pullDownView.shoudRemind = status
    shouldRemind = status
  }
  
  func setScrollViewOffset() {
    scorllView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
  }
  
  func headViewContext(should: Bool,timeString: String) {
    headView.timeString = timeString
    headView.shoudRemind = should
  }
  
  func endScroll(end: Bool) {
    scorllView.pullDownView.endDragging = end
    headView.endDragging = end
  }
  
  func initialUI() {
    scorllView.mainView.animationBegin()
    headView.initialTextString()
  }
  
  func updateUI(weatherResult: WeatherResult) {
    if weatherResult.city == "" {
      return
    }
    scorllView.mainView.updateAndAnimation(weatherResult)
    headView.updateUI(weatherResult.city)
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
}

extension HomeView: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let offSety = scrollView.contentOffset.y
    showTimePicker = false
    
    if offSety < -85 {
      showTimePicker = true
      if shouldRemind == true && offSety <= -100 {
        showTimePicker = false
      }
    }
    headView.offsetY = offSety
    scorllView.didScroll(offSety)
    delegate?.HomeViewDidScroll(self, offsety: offSety)
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offSety = scrollView.contentOffset.y
    
    if decelerate == true {
      endScroll(decelerate)
     delegate?.HomeViewEndDragging(self,offsety:offSety, showTimePicker: showTimePicker)
    }
  }
}
