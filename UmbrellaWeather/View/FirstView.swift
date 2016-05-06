//
//  FirstView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/28.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

class FirstView: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadViewFormNib()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadViewFormNib()
      fatalError("init(coder:) has not been implemented")
  }
  
  func loadViewFormNib(){
    let bundle = NSBundle(forClass: self.dynamicType)
    let nib = UINib(nibName: "FirstView", bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
    view.frame = bounds
    self.addSubview(view)
  }
  
  class func firstViewButton(superView: UIView) -> UIButton {
    let firstView = FirstView()
    firstView.frame = superView.bounds
    let button = UIButton()
    button.bounds.size = CGSize(width: 100, height: 50)
    button.center = superView.center
    button.setTitle("开始吧!", forState: .Normal)
    button.backgroundColor = superView.tintColor
//    button.addTarget(superView, action: <#T##Selector#>, forControlEvents: .TouchUpInside)
    firstView.addSubview(button)
//    button.addTarget(self, action: #selector(HomeViewController.touchBegin(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    
    superView.addSubview(firstView)
    
    return button
  }
  
  func showViewWithFirstTime(){
  
  }
  
//  func touchBegin(sender: UIButton){
//    firstView.removeFromSuperview()
//    updateWeatherResult()
//  }
  
}
