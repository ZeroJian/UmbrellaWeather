//
//  HomeView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/5/4.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

enum ScrollStatus {
  case DidScroll;
  case EndDragging;
}

protocol HomeViewDelegate: class {
  func HomeViewScrollStatus(view: HomeView, status: ScrollStatus,offsety: CGFloat,showTimePicker: Bool)
}

class HomeView: UIView {
  
  
  @IBOutlet weak var scorllView: MainScrollView! {
    didSet {
      scorllView.delegate = self
    }
  }
  
  @IBOutlet weak var headView: HeadView!
  
  enum LoadingAnimation {
    case Loading
    case Finish
  }
  
  weak var delegate: HomeViewDelegate?
  
  var showTimePicker: Bool!
  
  var shouldRemind: Bool!
  
  var endDragging: Bool!
  
  func showRemindStatus(withTimeString time: String, remind: Bool) {
    headView.timeString = time
    headView.remindStatus = remind
    if remind {
      headView.detailButton.setBackgroundImage(UIImage(named: "DetailColor"), forState: .Normal)
    }
  }
  
  func loadingAnimationStatus(stauts:LoadingAnimation) {
    switch stauts {
    case .Loading:
      if !scorllView.weatherView.loading {
        scorllView.weatherView.loadingAnimated()
      }
    case .Finish:
      scorllView.weatherView.loadingFinish()
    }
  }
  
  func remindStatus(status: Bool) {
    scorllView.pullDownView.shoudRemind = status
    shouldRemind = status
  }
  
  func initialScrollViewOffset() {
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
    scorllView.weatherView.animationBegin()
    headView.initialTextString()
  }
  
  func updateUI(weatherResult: WeatherResult) {
    if weatherResult.city == "" {
      return
    }
    scorllView.weatherView.updateAndAnimation(weatherResult)
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
    delegate?.HomeViewScrollStatus(self, status: .DidScroll, offsety: offSety, showTimePicker: false)
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offSety = scrollView.contentOffset.y
    if decelerate == true {
      endScroll(decelerate)
      delegate?.HomeViewScrollStatus(self, status: .EndDragging, offsety: offSety, showTimePicker: showTimePicker)
    }
  }
}
