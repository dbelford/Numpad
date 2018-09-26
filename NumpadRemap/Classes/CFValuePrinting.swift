//
//  CFValuePrinting.swift
//  NumpadRemap
//
//  Created by David Belford on 9/25/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation


public func CFValueString(_ property: String, _ value: CFTypeRef) -> String? {
  switch CFGetTypeID(value) {
  case CFStringGetTypeID():
    guard let s = value as? String else { return nil }
    return "\(s)"
  case CFNumberGetTypeID():
    guard let n = value as? NSNumber else { return nil }
    return "\(n.stringValue)"
  case CFDictionaryGetTypeID():
    let d = value as! CFDictionary
    let d2 = d as NSDictionary
    return String(describing: d2)
    //        guard let v = value as? NSDictionary else { return nil }
  //    return "CFDictionary Print Implementation"
  case CFArrayGetTypeID():
    let d = value as! CFArray
    let d2 = d as [CFTypeRef]
    return String(describing: d2)
  case CFSetGetTypeID():
    let d = value as! CFSet
    let d2 = d as NSSet
    return String(describing: d2)
  case CFBooleanGetTypeID():
    guard let n = value as? Bool else { return nil }
    return "\(n ? "true" : "false" )"
  //  case CFGetTypeID
  default:
    let s = value as? Any
    return "\(s)"
    //    return "Did not match CFTypeID"
  }
}
