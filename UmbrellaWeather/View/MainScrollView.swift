//
//  MainScrollView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/5/4.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

protocol MainScrollViewDelegate: class {
  func offsetYOfMainScrollView(view: MainScrollView,offsetY: CGFloat)
  func  endScrollOfMainScrollView(view: MainScrollView) -> Bool!
  
}


class MainScrollView: UIScrollView {
  
  @IBOutlet weak var mainView: MainView!
  @IBOutlet weak var pullDownView: PullView!
  
  weak var mainDelegate: MainScrollViewDelegate?
  
  
  var offsetY: CGFloat? {
    didSet {
      if offsetY < -30 {
      }
    }
  }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
  
 
  
}

extension MainScrollView: UIScrollViewDelegate {
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    offsetY = scrollView.contentOffset.y
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    <#code#>
  }
  
}
