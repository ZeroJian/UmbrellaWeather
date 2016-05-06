//
//  HeadView.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/5/4.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

protocol HeadViewDelegate: class {
  func buttonTapForHeadView(view: HeadView,sender: UIButton)
}

class HeadView: UIView {
  
  @IBOutlet weak var detailButton: UIButton!
  @IBOutlet weak var cityButton: UIButton!
  @IBOutlet weak var dateView: UIView!
  @IBOutlet weak var dateLabel: UILabel!
  
  weak var delegate: HeadViewDelegate?
  
  var timeString: String!{
    willSet {
     
//      springAnimation1(dateView)
      
    }
    
  }
  
  var endDragging: Bool? {
    willSet{
      if newValue == true {
        dateView.backgroundColor = UIColor.shallowBlack()
      if dateString != nil {
          dateLabel.text = dateString
      }
      }
    }
    
    didSet{
      endDragging = nil
    }
  }
  
  var dateString: String!
  
  var shoudRemind: Bool! {
    willSet {
      springAnimation1(dateView)
      dateView.backgroundColor = UIColor.rainColor()
      dateLabel.text = timeString
      remindStatus = newValue
    if newValue == true {
//      springAnimation1(dateView)
//      dateLabel.text = timeString
      
      
      detailButton.setBackgroundImage(UIImage(named: "DetailColor"), forState: .Normal)
    } else if newValue == false {
//        dateView.backgroundColor = self.tintColor
      
       detailButton.setBackgroundImage(UIImage(named: "Detail"), forState: .Normal)
      }
    }
  }
  
  var remindStatus: Bool!
  
  var offsetY: CGFloat! {
    willSet {
      print(timeString)
      if endDragging != true {
      if newValue <= -60 {
        dateLabel.text = timeString
        dateView.backgroundColor = self.tintColor
        print("headview <= -60")
        if remindStatus == true && newValue <= -100 {
          dateLabel.text = timeString
          dateView.backgroundColor = UIColor.shallowBlack()
        }
        
      } else {
        if dateString != "" {
          dateLabel.text = dateString
        }
        dateView.backgroundColor = UIColor.shallowBlack()
      }
    }
    }
  }
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
//    initialTextString()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
//    initialTextString()
  }
  
  func initialTextString() {
    cityButton.titleLabel?.text = "   "
    cityButton.setTitle("   ", forState: .Normal)
    dateLabel.text = ""
  }
  
  func initialRemindStatus(time: String, remind: Bool) {
    timeString = time
    remindStatus = remind
    if remind {
    detailButton.setBackgroundImage(UIImage(named: "DetailColor"), forState: .Normal)
    }
  }
  
  func updateUI(cityName: String!) {
    cityButton.setTitle(cityName, forState: .Normal)
    
    if dateString != nil {
      dateLabel.text = dateString
    } else {
    let currentdate = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let  convertedDate = dateFormatter.stringFromDate(currentdate)
    dateLabel.text = convertedDate
    dateString = convertedDate
    }
  }
  
  @IBAction func headButton(sender: UIButton) {
    initialTextString()
//  NSNotificationCenter.defaultCenter().postNotificationName("headButton"  , object: nil)
    
    NSNotificationCenter.defaultCenter().postNotificationName("HeadButton", object: nil, userInfo: ["sender": sender])
    print("button taped")
  }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
