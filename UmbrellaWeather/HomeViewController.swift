//
//  HomeViewController.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/21.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit
import AudioToolbox

class HomeViewController: UIViewController,TimePickerViewControllerDelegate,SupportTableViewControllerDelegate,CityListViewControllerDelegate,HomeViewDelegate{

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var homeView: HomeView!
  
  var serviceResult = ServiceResult()
  var dataModel: DataModel!
  var observer: AnyObject!
  var buttonClicked = false
  var soundID: SystemSoundID = 0
  
  override func viewDidLoad() {
        super.viewDidLoad()
    loadSoundEffect("WaterSound.wav")
    launchAnimation(self.view) { (finishion) in
      if finishion{
        self.handleFirstTime()
      }
    }
    homeView.showRemindStatus(withTimeString:dataModel.dueString, remind: dataModel.shouldRemind)
    homeView.delegate = self
    listenForLocation()
  }
  
  override func viewDidDisappear(animated: Bool) {
    homeView.initialUI()
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func location() {
    
    buttonClicked = true
    
    updateWeatherResult()
  }

  func updateWeatherResult(){
    homeView.initialUI()
    
    if dataModel.currentCity == "" || buttonClicked == true{
      buttonClicked = false
      locationCity()
    }else{
      perforRequest()
    }
  }
  
  func listenForLocation() {
    observer = NSNotificationCenter.defaultCenter().addObserverForName("Location_Denied", object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { [weak self](_) in
      self?.showAlert("没有打开定位服务请在设置中打开定位或上拉搜索选择城市", "好的", againReuqest:  false, shouldRemind: false)
      })
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
  func locationCity(){
    LocationService.startLocation()
    LocationService.sharedManager.afterUpdatedCityAction = {
      [weak self] sucess in
      if !sucess{
        self?.homeView.loadingAnimationStatus(.Finish)
        let message = "定位失败,请稍后重试或上滑视图打开城市搜索"
        self?.showAlert(message, "好的", againReuqest: false, shouldRemind: false)
      }
      self?.showLocationStatus()
    }
    showLocationStatus()
  }
  
  
  func showLocationStatus(){
    switch LocationService.sharedManager.locationStatus{
    case .Loading:
      homeView.loadingAnimationStatus(.Loading)
    case .Result(let city):
        dataModel.currentCity = city
        perforRequest()
    case .Normal:
      return
    }
  }
  
  func perforRequest(){
      serviceResult.performResult(dataModel.currentCity) { success in
        print("网络请求")
        if !success{
          self.homeView.loadingAnimationStatus(.Finish)
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
      homeView.loadingAnimationStatus(.Loading)
    case .Results(let result):
      dataModel.weatherResult = result
      updateUI()
      homeView.loadingAnimationStatus(.Finish)
    case .NoRequest:
      let message = "今天服务器请求已经超过访问次数,请明天再试"
      showAlert(message,"好的", againReuqest: false,shouldRemind: false)
      homeView.loadingAnimationStatus(.Finish)
    case .NonsupportCity:
      dataModel.currentCity = ""
      let message = "很抱歉,服务器暂不支持此城市,请在城市搜索界面查找其他城市"
      showAlert(message, "好的", againReuqest: false, shouldRemind: false)
      homeView.loadingAnimationStatus(.Finish)
      break
    case .NoYet:
      return
    }
  }
  
  func updateUI(){
    homeView.updateUI(dataModel.weatherResult)
    collectionView.reloadData()
  }
  
  //设置第一次启动引导
  func handleFirstTime(){
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let firstTime = userDefaults.boolForKey("FirstTime")
    if firstTime{
      let firstView = FirstView.showView(self.view)
      firstView.doneButton.addTarget(self, action: #selector(touchBegin), forControlEvents: .TouchUpInside)
      firstView.tag = 1000;
      userDefaults.setBool(false, forKey: "FirstTime")
      userDefaults.synchronize()
    }else{
      updateWeatherResult()
    }
  }
  
  func touchBegin(){
    self.view .viewWithTag(1000)!.removeFromSuperview()
    updateWeatherResult()
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
    
    dataModel.shouldRemind = should
    if should{
      playSoundEffect()
      let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
      UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }else{
      self.dataModel.dueString = "__ : __"
    }
    homeView.headViewContext(should, timeString: dataModel.dueString)
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
    homeView.initialScrollViewOffset()
    self.performSelector(#selector(HomeViewController.updateUI), withObject: nil, afterDelay: 0.3)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func cityListViewControolerDidSelectCity(controller: CityListViewController, didSelectCity city: City) {
    
    //减少网络请求次数,相同城市只有动画效果不重新加载网络请求
    if dataModel.currentCity == city.cityCN{
      self.performSelector(#selector(HomeViewController.updateUI), withObject: nil, afterDelay: 0.3)
    }else{
      dataModel.currentCity = city.cityCN
      updateWeatherResult()
    }
    dataModel.appendCity(city)
    homeView.initialScrollViewOffset()
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func cityListViewControllerDeleteCity(controller: CityListViewController, currentCities cities: [City]){
    dataModel.cities = cities
  }
  
  func cityListViewControllerCancel(controller: CityListViewController) {
    homeView.initialScrollViewOffset()
    self.performSelector(#selector(HomeViewController.updateUI), withObject: nil, afterDelay: 0.3)
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func HomeViewScrollStatus(view: HomeView, status: ScrollStatus, offsety: CGFloat, showTimePicker: Bool) {
    switch status {
    case .DidScroll:
      homeView.remindStatus(dataModel.shouldRemind)
    case .EndDragging:
      if showTimePicker {
        performSegueWithIdentifier("TimePicker", sender: self)
      }
      if offsety <= -100 && !showTimePicker{
        showAlert("","不取消", againReuqest: false, shouldRemind: true)
      }
      if offsety >= 260{
        performSegueWithIdentifier("CityList", sender: self)
      }
    }
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


extension HomeViewController: UICollectionViewDataSource{
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataModel.weatherResult.dailyResults.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeekWeatherCell", forIndexPath: indexPath) as! WeekWeatherCell
    
    let dailyResult = dataModel.weatherResult.dailyResults[indexPath.item]
    cell.configureForDailyResult(dailyResult)
    
    return cell
  }
}
