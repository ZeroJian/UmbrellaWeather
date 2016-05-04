//
//  PullViewController.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/24.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

class PullView: UIView {
  

  @IBOutlet weak var remindLabel: UILabel!
  @IBOutlet weak var lineImage: UIImageView!
  @IBOutlet weak var lineXConstraion: NSLayoutConstraint!
  @IBOutlet weak var topHeightConstraion: NSLayoutConstraint!
  @IBOutlet weak var buttonHeightConstraion: NSLayoutConstraint!
  
  
  var shoudRemind: Bool! {
    didSet {
      if oldValue == true {
        remindString = "释放更换通知时间"
      }else if oldValue == false {
        remindString = "释放激活下雨通知"
      }
    }
  }
  
  var remindString: String!
  
  var offsetY: CGFloat! {
    didSet {
      if offsetY < -30 {
        lineAnimation()
        topHeightConstraion.constant = abs(offsetY)
        self.hidden = false
        if offsetY <= -60 && offsetY > -100 {
          viewDidScroll("↓下拉设置通知", labelColor: UIColor.whiteColor(), alpha: 0.04 * (abs(offsetY) - 60), hidden: false)
          animationWithColor(self,color:self.tintColor)
          if offsetY < -85 {
            viewDidScroll(remindString, labelColor: UIColor.whiteColor(), alpha: 1, hidden: false)
          }
          if shoudRemind == true && offsetY <= -100 {
            remindLabel.text = ""
            remindLabel.textColor = self.tintColor
            animationWithColor(self, color: UIColor.brownColor())
          }
        }
      } else if offsetY > 200 {
        buttonHeightConstraion.constant = offsetY - 190
      } else {
        hiddenView()
//        self.backgroundColor = UIColor.brownColor()
      }
      
    }
  }

  func viewDidScroll(labelText: String!,labelColor: UIColor,alpha: CGFloat,hidden: Bool){
    remindLabel.hidden = hidden
    remindLabel.text = labelText
    remindLabel.textColor = labelColor
    remindLabel.alpha = alpha
  }
  
  
  func lineAnimated(offsetY: CGFloat) {
    if offsetY < -30 {
      lineAnimation()
    }
  }
  
  
  func lineAnimation(){
    lineXConstraion.constant = self.bounds.width
    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.layoutIfNeeded()
      }, completion: nil)
  }
  
  func initialLine(){
    lineXConstraion.constant -= lineImage.bounds.width
  }
  
  func hiddenView(){
    self.hidden = true
    remindLabel.hidden = true
    remindLabel.alpha = 0
    topHeightConstraion.constant = 0
    self.backgroundColor = UIColor.brownColor()
    lineXConstraion.constant -= lineImage.bounds.width
  }
 
}
