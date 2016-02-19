//
//  ParserXML.swift
//  UmberellaWeather
//
//  Created by ZeroJianMBP on 16/1/1.
//  Copyright © 2016年 ZeroJian. All rights reserved.
//

import Foundation

class ParserXML: NSObject,NSXMLParserDelegate{
  
  var elementName = ""
  var cities = [City]()
  
  override init(){
    super.init()
    parseXMLResource()
  }
  
  func parseXMLResource(){
    let parser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Citys", ofType: "xml")!))
    if let parser = parser{
      parser.delegate = self
      parser.parse()
    }
  }
  
  func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
    self.elementName = elementName
  }
  
  func parser(parser: NSXMLParser, foundCharacters string: String) {
    let str = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    if elementName == "city"{
      let city = City()
      city.cityCN = str
      cities.append(city)
    }
  }
}