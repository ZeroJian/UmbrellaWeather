//
//  FirstView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/28.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

class FirstView: UIView {
  
  var doneButton: UIButton!
  
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
  
  class func showView(superview: UIView) -> FirstView {
    let firstView = FirstView()
    firstView.frame = superview.bounds
    superview.addSubview(firstView)
    
    firstView.doneButton = UIButton()
    firstView.doneButton.bounds.size = CGSize(width: 100, height: 50)
    firstView.doneButton.center = firstView.center
    firstView.doneButton.setTitle("开始吧!", forState: .Normal)
    firstView.doneButton.backgroundColor = UIColor.rainColor()
    firstView.addSubview(firstView.doneButton)
    return firstView
  }
  
}
