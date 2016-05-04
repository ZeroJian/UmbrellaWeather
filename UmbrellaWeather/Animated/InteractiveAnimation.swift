//
//  InteractiveAnimation.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/24.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

typealias animationFinshion = (Bool) -> Void


  func springAnimation1(currtntView: UIView){
    currtntView.transform = CGAffineTransformMakeScale(0.8, 0.8)
    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: { () -> Void in
      currtntView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }, completion: nil)
  }
  
  func animationWithColor(superView: UIView,color: UIColor){
    UIView.transitionWithView(superView, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
      superView.backgroundColor = color
      }, completion: nil)
  }
  
  func loadingAnimation(imageView: UIImageView){
    if imageView.hidden{
      imageView.hidden = false
    }
    rotationAnimated(imageView)
  }
  
  private func rotationAnimated(imageView: UIImageView){
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.toValue = NSNumber(double: M_PI * 2.0)
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    rotationAnimation.duration = 0.3
    rotationAnimation.repeatCount = MAXFLOAT
    rotationAnimation.cumulative = false
    rotationAnimation.removedOnCompletion = false
    rotationAnimation.fillMode = kCAFillModeForwards
    imageView.layer.addAnimation(rotationAnimation, forKey: "Rotation")
  }
  
  func launchAnimation(currentView: UIView,finishion: animationFinshion){
    var animationDone = false
    let launchView = UIImageView(frame: currentView.bounds)
    launchView.imageWithResolution()
    currentView.transform = CGAffineTransformMakeScale(0.8, 0.8)
    launchView.transform = CGAffineTransformMakeScale(1.25, 1.25)
    currentView.addSubview(launchView)
    //启动图片扩大消失动画
    UIView.animateWithDuration(0.3, delay: 0.9, options: [], animations: {
      launchView.transform = CGAffineTransformMakeScale(2.0, 2.0)
      launchView.alpha = 0.0
      }) { (_) in
        launchView.removeFromSuperview()
    }
    //主视图扩大弹跳动画
    UIView.animateWithDuration(0.3, delay: 1.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: [], animations: { () -> Void in
      currentView.transform = CGAffineTransformMakeScale(1.0, 1.0)
      }){ (_) in
      animationDone = true
      finishion(animationDone)
    }
  }

