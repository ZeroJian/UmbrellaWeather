//
//  GradientView.swift
//  UmberellaWeather
//
//  Created by ZeroJianMBP on 15/12/30.
//  Copyright © 2015年 ZeroJian. All rights reserved.
//

import UIKit

class GradientView: UIView{
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.clearColor()
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    backgroundColor = UIColor.clearColor()
  }
}
