//
//  HomeViewController.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/21.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit
import AudioToolbox

class HomeViewController: UIViewController,TimePickerViewControllerDelegate,SupportTableViewControllerDelegate,CityListViewControllerDelegate{

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pullDownView: PullView!
  @IBOutlet weak var pullTopView: PullView!
  @IBOutlet weak var mainView: MainView!
  @IBOutlet weak var cityButton: UIButton!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var dateView: UIView!
  @IBOutlet weak var detailButton: UIButton!
  
  var weatherResult = WeatherResult()
  var serviceResult = ServiceResult()
  var dataModel: DataModel!
  var firstView: UIView!
  var dateString: String!
  var shoudRemand = false
  var soundID: SystemSoundID = 0
  
  override func viewDidLoad() {
        super.viewDidLoad()
    loadSoundEffect("WaterSound.wav")
    initialUI()
    launchAnimation(self.view) { (finishion) in
      if finishion{
        self.handleFirstTime()
      }
    }
    if dataModel.shouldRemind{
      detailButton.setBackgroundImage(UIImage(named: "DetailColor"), forState: .Normal)
    }
  }
  
  @IBAction func locationButton(sender: UIButton){
    updateWeatherResult()
    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
  }
  
  func updateWeatherResult(){
    initialUI()
    
    if dataModel.currentCity == "" || cityButton.touchInside{
     locationCity()
    }else{
      perforRequest()
    }
  }
  
  func locationCity(){
    let locationService = LocationService.singleClass
    locationService.beginLocation()

    locationService.afterUpdatedCityAction = {
      [weak self] sucess in
      if !sucess{
        self?.mainView.loadingFinish()
        let message = "定位失败,请稍后重试或上滑视图打开城市搜索"
        self?.showAlert(message, "好的", againReuqest: false, shouldRemind: false)
      }
      self?.showLocationStatus(locationService)
    }
    showLocationStatus(locationService)
  }
  
  func showLocationStatus(locationService: LocationService){
    switch locationService.locationState{
    case .NoService:
      if mainView.loading{
        mainView.loadingFinish()
      }
      let message = "没有打开定位服务,请在系统设置里激活程序的定位服务,或上拉视图到底部打开城市搜索添加城市"
      showAlert(message, "好的", againReuqest: false, shouldRemind: false)
    case .Loading:
      if !mainView.loading{
        mainView.loadingAnimated()
      }
    case .Result(let city):
      mainView.loadingFinish()
        dataModel.currentCity = city
        perforRequest()
    case .Normal:
      return
    }
  }
  
  override func viewDidDisappear(animated: Bool) {
    initialUI()
  }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func initialUI(){
    mainView.animationBegin()
    
    //不设置两次 Button 的 Title 会出现几帧省略号 bug?
    cityButton.titleLabel?.text = "   "
    cityButton.setTitle("   ", forState: .Normal)
    
    dateLabel.text = ""
  }
  
  func perforRequest(){
      serviceResult.performResult(dataModel.currentCity) { success in
        print("网络请求")
        if !success{
          self.mainView.loadingFinish()
          let message = "网络请求出现错误,请稍后重试"
          self.showAlert(message,"取消", againReuqest: true,shouldRemind: false)
        }
        self.showRequestStatus()
      }
      showRequestStatus()
  }
  
  func showRequestStatus(){
    switch serviceResult.state{
    case .Loading:
      if !mainView.loading{
         mainView.loadingAnimated()
      }
    case .Results(let result):
      weatherResult = result
      dataModel.dailyResults = weatherResult.dailyResults
      updateUI()
      mainView.loadingFinish()
    case .NoRequest:
      let message = "今天服务器请求已经超过访问次数,请明天再试"
      showAlert(message,"好的", againReuqest: false,shouldRemind: false)
      mainView.loadingFinish()
    case .NonsupportCity:
      dataModel.currentCity = ""
      let message = "很抱歉,服务器暂不支持此城市,请在城市搜索界面查找其他城市"
      showAlert(message, "好的", againReuqest: false, shouldRemind: false)
      mainView.loadingFinish()
    case .NoYet:
      return
    }
   
  }
  
  func updateUI(){
    if weatherResult.city == ""{
     return
    }
    mainView.updateAndAnimation(weatherResult)
    cityButton.setTitle(weatherResult.city, forState: .Normal)
    let currentdate = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let  convertedDate = dateFormatter.stringFromDate(currentdate)
    dateLabel.text = convertedDate
    dateString = convertedDate
    collectionView.reloadData()
  }
  
  //设置第一次启动引导
  func handleFirstTime(){
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let firstTime = userDefaults.boolForKey("FirstTime")
    if firstTime{
      showViewWithFirstTime()
      userDefaults.setBool(false, forKey: "FirstTime")
      userDefaults.synchronize()
    }else{
      updateWeatherResult()
    }
  }
  
  func showAlert(message: String, _ actionTitle: String,againReuqest: Bool,shouldRemind: Bool){
    
    let alertTitle = shouldRemind ? "确定取消天气通知吗?" : "发生错误"
    let alertStyle = shouldRemind ? UIAlertControllerStyle.ActionSheet : .Alert
    let actionDoneTitle = shouldRemind ? "取消通知" : "重试"
    
    let alert = UIAlertController(title: alertTitle, message: message , preferredStyle: alertStyle)
    
    if againReuqest || shouldRemind{
      let actionRequest = UIAlertAction(title: actionDoneTitle, style: .Default, handler: { (action) -> Void in
        if shouldRemind{
          
          self.shoudldNotification(false)
        }else{
          self.perforRequest()
        }
      })
      alert.addAction(actionRequest)
    }
    
    let actionCancel = UIAlertAction(title: actionTitle, style: .Default, handler: {(_) in
      self.updateUI()
    })
    
    alert.addAction(actionCancel)
    
    presentViewController(alert, animated: true, completion: nil)
  }
 
  func shoudldNotification(should: Bool){
    if should{
      playSoundEffect()
      dataModel.shouldRemind = true
      dateLabel.text = dataModel.dueString
      dateView.backgroundColor = mainView.rainPercentLabel.textColor
      springAnimation1(dateView)
      detailButton.setBackgroundImage(UIImage(named: "DetailColor"), forState: .Normal)
      
      let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
      UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }else{
      springAnimation1(dateView)
      self.dateView.backgroundColor = self.view.tintColor
      self.dataModel.dueString = "__ : __"
      self.dateLabel.text = dataModel.dueString
      self.dataModel.shouldRemind = false
      detailButton.setBackgroundImage(UIImage(named: "Detail"), forState: .Normal)
    }
  }
  
  // MARK: - Sound Effect
  func loadSoundEffect(name: String){
    if let path = NSBundle.mainBundle().pathForResource(name, ofType: nil){
      let fileURL = NSURL.fileURLWithPath(path, isDirectory: false)
      let error = AudioServicesCreateSystemSoundID(fileURL, &soundID)
      if error != kAudioServicesNoError{
        print("Sound Error: \(error), path: \(path)")
      }
    }
  }
  
  func unloadSoundEffect(){
    AudioServicesDisposeSystemSoundID(soundID)
    soundID = 0
  }
  
  func playSoundEffect(){
    AudioServicesPlaySystemSound(soundID)
  }
  
  func timePickerViewControllerDidSelect(controller: TimePickerViewController, didSelectTime time: String) {
    dataModel.dueString = time
    shoudldNotification(true)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func timePickerViewControllerDidCancel(controller: TimePickerViewController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func supportTableViewController(controller: SupportTableViewController) {
    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    self.performSelector("updateUI", withObject: nil, afterDelay: 0.3)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func cityListViewControolerDidSelectCity(controller: CityListViewController, didSelectCity city: City) {
    
    //减少网络请求次数,相同城市只有动画效果不重新加载网络请求
    if dataModel.currentCity == city.cityCN{
      self.performSelector("updateUI", withObject: nil, afterDelay: 0.3)
    }else{
      dataModel.currentCity = city.cityCN
      updateWeatherResult()
    }
    dataModel.appendCity(city)
    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func cityListViewControllerDeleteCity(controller: CityListViewController, currentCities cities: [City]){
    dataModel.cities = cities
  }
  
  func cityListViewControllerCancel(controller: CityListViewController) {
    scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    self.performSelector("updateUI", withObject: nil, afterDelay: 0.3)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func showViewWithFirstTime(){
    firstView = FirstView()
    firstView.frame = view.bounds
    let button = UIButton()
    button.bounds.size = CGSize(width: 100, height: 50)
    button.center = view.center
    button.setTitle("开始吧!", forState: .Normal)
    button.backgroundColor = view.tintColor
    firstView.addSubview(button)
    button.addTarget(self, action: Selector("touchBegin:"), forControlEvents: UIControlEvents.TouchUpInside)
    
    view.addSubview(firstView)
  }
  
  func touchBegin(sender: UIButton){
    firstView.removeFromSuperview()
    updateWeatherResult()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "TimePicker"{
      let controller = segue.destinationViewController as! TimePickerViewController
      controller.delegate = self
    }
    if segue.identifier == "SupportView"{
     let controller = segue.destinationViewController as! SupportTableViewController
      controller.delegate = self
    }
    if segue.identifier == "CityList"{
      let controller = segue.destinationViewController as! CityListViewController
      controller.delegate = self
      controller.cities = dataModel.cities
    }
  }
}

extension HomeViewController: UIScrollViewDelegate{
  func scrollViewDidScroll(scrollView: UIScrollView) {
    
    let offSety = scrollView.contentOffset.y
    
    if offSety < -30{
      pullDownView.lineAnimation()
      pullDownView.topHeightConstraion.constant = abs(offSety)
      pullDownView.hidden = false
      if offSety <= -60 && offSety > -100{
        shoudRemand = false
       
        pullDownView.viewDidScroll("↓下拉设置通知", labelColor: UIColor.whiteColor(), alpha: 0.04 * (abs(offSety) - 60), hidden: false)
        dateLabel.text = dataModel.dueString
        dateView.backgroundColor = view.tintColor
        animationWithColor(pullDownView,color:view.tintColor)
        if offSety < -85{
          shoudRemand = true
          let remindString: String!
          if dataModel.shouldRemind{
            remindString = "释放更换通知时间"
          }else{
            remindString = "释放激活下雨通知"
          }
          pullDownView.viewDidScroll(remindString, labelColor: UIColor.whiteColor(), alpha: 1, hidden: false)
        }
      }
      if dataModel.shouldRemind && offSety <= -100{
        shoudRemand = false
        pullDownView.remindLabel.text = "释放取消通知"
        pullDownView.remindLabel.textColor = view.tintColor
        dateLabel.text = dataModel.dueString
        dateView.backgroundColor = collectionView.backgroundColor
        animationWithColor(pullDownView, color: collectionView.backgroundColor!)
      }
    }else if offSety >= 40 && offSety <= 140{
      mainView.weatherImage.alpha = 1 - (0.02 * (offSety - 30))
    }else if offSety > 200{
      pullTopView.buttonHeightConstraion.constant = offSety - 190
    }else{
      shoudRemand = false
      pullDownView.hiddenView()
      pullDownView.backgroundColor = collectionView.backgroundColor
      pullDownView.initialLine()
      dateLabel.text = dateString
      dateView.backgroundColor = collectionView.backgroundColor
      mainView.weatherImage.alpha = 1
    }
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let offSety = scrollView.contentOffset.y
    if decelerate{
      if shoudRemand{
        pullDownView.hiddenView()
        performSegueWithIdentifier("TimePicker", sender: scrollView)
      }
      if offSety <= -100 && pullDownView.remindLabel.text == "释放取消通知"{
        pullDownView.hiddenView()
        showAlert("","不取消", againReuqest: false, shouldRemind: true)
      }
      if offSety >= 260{
        performSegueWithIdentifier("CityList", sender: scrollView)
      }
    }
  }
}

extension HomeViewController: UICollectionViewDataSource{
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return weatherResult.dailyResults.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeekWeatherCell", forIndexPath: indexPath) as! WeekWeatherCell
    
    let dailyResult = weatherResult.dailyResults[indexPath.item]
    cell.configureForDailyResult(dailyResult)
    
    return cell
  }
}
