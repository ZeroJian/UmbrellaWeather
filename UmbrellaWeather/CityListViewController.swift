//
//  CityListViewController.swift
//  UmbrellaWeather
//
//  Created by ZeroJianMBP on 16/1/23.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import UIKit

protocol CityListViewControllerDelegate: class{
  func cityListViewControolerDidSelectCity(controller: CityListViewController, didSelectCity city: City)
  func cityListViewControllerCancel(controller: CityListViewController)
  func cityListViewControllerDeleteCity(controller: CityListViewController, currentCities cities: [City])
}


class CityListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var headerView: UIView!
  @IBOutlet weak var headerYConstraion: NSLayoutConstraint!
  weak var delegate: CityListViewControllerDelegate?
  
  var cities = [City]()
  var filteredCities = [City]()
  var parserCities = [City]()
  var parserXML:ParserXML!

    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
      headerYConstraion.constant -= view.bounds.height - 60
      
      let cellNib = UINib(nibName: "CityListCell", bundle: nil)
      tableView.registerNib(cellNib, forCellReuseIdentifier: "CityListCell")
    }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    headerView.hidden = false
    headerYConstraion.constant = 0
    
    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
      self.view.layoutIfNeeded()
      }, completion: nil)
    
  }
  
  func filterControllerForSearchText(searchText: String, scope: String = "ALL"){
    filteredCities = parserCities.filter({ (city) -> Bool in
      return city.cityCN.lowercaseString.containsString(searchText.lowercaseString)
    })
    tableView.reloadData()
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  deinit{
    parserXML = nil
    filteredCities = []
    searchBar.delegate = nil
  }
}

extension CityListViewController: UISearchBarDelegate{
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    filterControllerForSearchText(searchBar.text!)
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if parserCities.isEmpty{
      parserXML = ParserXML()
      parserCities = parserXML.cities
    }
    
    filterControllerForSearchText(searchText)
  }
}

extension CityListViewController : UITableViewDelegate{
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let delegate = delegate{
      let city: City
      
      if !filteredCities.isEmpty{
        city = filteredCities[indexPath.row]
      }else{
        city = cities[indexPath.row]
      }
      delegate.cityListViewControolerDidSelectCity(self, didSelectCity: city)
    }
    searchBar.resignFirstResponder()
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  
  }
  
  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if searchBar.text != ""{
      return false
    }else{
      return true
    }
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    cities.removeAtIndex(indexPath.row)
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    delegate?.cityListViewControllerDeleteCity(self, currentCities: cities)
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let offSetY = scrollView.contentOffset.y
    searchBar.resignFirstResponder()
    
    if offSetY < -64{
      headerYConstraion.constant = -(abs(offSetY) - 64)
    }else{
      headerYConstraion.constant = 0
    }
    
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
    let offSetY = scrollView.contentOffset.y
    
    if decelerate && offSetY < -110{
      headerView.hidden = true
      delegate?.cityListViewControllerCancel(self)
    }
  }
  
}

extension CityListViewController: UITableViewDataSource{
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let city: City
    if searchBar.text != ""{
      let cell = tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath)
      cell.textLabel?.textColor = UIColor.whiteColor()
      city = filteredCities[indexPath.row]
      cell.textLabel?.text = city.cityCN
      return cell
    }else{
      let cell = tableView.dequeueReusableCellWithIdentifier("CityListCell", forIndexPath: indexPath) as! CityListCell
      city = cities[indexPath.row]
      cell.addCityName(city)
      return cell
    }
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if  !filteredCities.isEmpty || searchBar.text != ""{
      return filteredCities.count
    }
      return cities.count
  }
  
}

