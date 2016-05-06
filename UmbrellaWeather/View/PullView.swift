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
    willSet {
      if newValue == true {
        remindString = "释放更换通知时间"
        if offsetY <= -100 {
          remindLabel.text = "释放取消通知"
          remindLabel.textColor = UIColor.GreenBlue()
          animationWithColor(self, color: UIColor.shallowBlack())
        }
        
        
      }else if newValue == false {
        remindString = "释放激活下雨通知"
      }
    }
  }
  
  var endDragging: Bool? {
    willSet{
      if newValue == true {
//        if shoudRemind == true {
          hiddenView()
      }
    }
    didSet {
      endDragging = nil
    }
  }
  
  var remindString: String!
  
  var offsetY: CGFloat! {
    willSet {
      
      if endDragging != true {
      if newValue < -30 {
        lineAnimation()
        topHeightConstraion.constant = abs(newValue)
        self.hidden = false
        
        if newValue <= -60 && newValue > -100 {
          
          viewDidScroll("↓下拉设置通知", alpha: 0.04 * (abs(newValue) - 60))
          animationWithColor(self,color:UIColor.GreenBlue())

          if newValue < -85 {
            viewDidScroll(remindString, alpha: 1)
          }
//          if shoudRemind == true && newValue <= -100 {
//            remindLabel.text = "释放取消通知"
//            remindLabel.textColor = UIColor.GreenBlue()
//            animationWithColor(self, color: UIColor.shallowBlack())
//          }
        }
        
      } else {
        if !self.hidden {
//        print("hiddenview")
        hiddenView()
//        self.backgroundColor = UIColor.brownColor()
        }
      }
      }
    }
  }

  func viewDidScroll(labelText: String!,alpha: CGFloat){
    remindLabel.hidden = false
    remindLabel.text = labelText
    remindLabel.textColor = UIColor.whiteColor()
    remindLabel.alpha = alpha
  }
  
  
  
  func lineAnimation(){
    lineImage.hidden = false
    lineXConstraion.constant = self.bounds.width
    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
      self.layoutIfNeeded()
      }, completion: nil)
  }
  
//  func initialLine(){
//    lineXConstraion.constant -= lineImage.bounds.width
//  }
  
  func hiddenView(){
    self.hidden = true
    remindLabel.hidden = true
    remindLabel.alpha = 0
    lineImage.hidden = true
    topHeightConstraion.constant = 0
    self.backgroundColor = UIColor.shallowBlack()
    lineXConstraion.constant -= lineImage.bounds.width
  }
 
}
