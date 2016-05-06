//
//  MainScrollView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/5/4.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

//protocol MainScrollViewDelegate: class {
//  func offsetYOfMainScrollView(view: MainScrollView,offsetY: CGFloat)
//  func  endScrollOfMainScrollView(view: MainScrollView) -> Bool!
//  
//}


class MainScrollView: UIScrollView {
  
  @IBOutlet weak var mainView: MainView!
  @IBOutlet weak var weakView: UIView!
  @IBOutlet weak var pullDownView: PullView!
  
//  weak var mainDelegate: MainScrollViewDelegate?
  
  
  func didScroll(offsetY: CGFloat) {
    pullDownView.offsetY = offsetY
    mainView.offsetY = offsetY
    
  }

    override init(frame: CGRect) {
      super.init(frame: frame)
  //    animationBegin()
      print("555555555")
    }
  
    required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)!
  //    animationBegin()
      print("555555555")
    }
  
}

