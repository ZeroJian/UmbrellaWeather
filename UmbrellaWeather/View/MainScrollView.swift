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
  
  @IBOutlet weak var weatherView: WeatherView!
  @IBOutlet weak var pullDownView: PullView!
  
  
  func didScroll(offsetY: CGFloat) {
    pullDownView.offsetY = offsetY
    weatherView.offsetY = offsetY
  }

  
}

