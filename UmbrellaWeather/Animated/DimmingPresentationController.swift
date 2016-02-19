//
//  DimmingPresentationController.swift
//  UmberellaWeather
//
//  Created by ZeroJianMBP on 15/12/30.
//  Copyright © 2015年 ZeroJian. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController{
  override func shouldRemovePresentersView() -> Bool {
    return false
  }
  
  lazy var dimmingView = GradientView(frame: CGRect.zero)
  override func presentationTransitionWillBegin() {
    dimmingView.frame = containerView!.bounds
    containerView!.insertSubview(dimmingView, atIndex: 0)
  }
}
