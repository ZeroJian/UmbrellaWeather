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

  func viewDidScroll(labelText: String!,labelColor: UIColor,alpha: CGFloat,hidden: Bool){
    remindLabel.hidden = hidden
    remindLabel.text = labelText
    remindLabel.textColor = labelColor
    remindLabel.alpha = alpha
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
  }
 
}
