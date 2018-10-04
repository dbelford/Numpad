//
//  HidDeviceObject.swift
//  NumpadRemap
//
//  Created by David Belford on 9/27/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

@objc
class HidDeviceObject : NSObject {
  var transport : String?
  var vendorID : Int?
  var vendorIDSource : Int?
  var productID : Int?
  var versionNumber : Int?
  var manufacturer : String?
  var product : String?
  var serialNumber : String?
  var countryCode : Int?
  //  var standardType : : ?
  var locationID : Int?
  //  var deviceUsage : Int?
  //  var deviceUsagePage : Int?
  var deviceUsagePairs : [[String : Int]]?
  var primaryUsage : Int?
  var primaryUsagePage : Int?
  var uniqueID : UInt
  
  //  var maxInputReportSize : Int
  //  var maxOutputReportSize : Int
  //  var maxFeatureReportSize : Int
  //  var reportInterval : Int
  //  var sampleInterval : Int
  //  var batchInterval : Int
  //  var requestTimeout : Int
  //  var reportDescriptor : [CFData] ??
  //  var reset : Int
  //  var keyboardLanguage : ??
  //  var altHandler : ??
  //  var builtIn : ???
  //  var displayIntegrated : ??
  //  var productIDMask : ??
  //  var productIDArray : ??
  //  var powerOnDelay : ??
  //  var category : ?
  //  var maxResponseLatency : ?
  //  var uniqueID : Int
  //  var physicalDeviceUniqueID : Int
  
  // FIXME: Cannot do Enum because Apple's strings are hidden...
  //  enum CodingKeys: CodingKey {
  //    case kIOHIDTransportKey  = kIOHIDTransportKey
  //    case vendorID  = kIOHIDVendorIDKey
  //    case vendorIDSource  = kIOHIDVendorIDSourceKey
  //    case productID  = Int?
  //    case versionNumber  = Int?
  //    case manufacturer  = String?
  //    case product  = String?
  //    case serialNumber  = String?
  //    case countryCode  = Int?
  //    //  case standardType  =  = ?
  //    case locationID  = Int?
  //    case deviceUsage  = Int?
  //    case deviceUsagePage  = Int?
  //    case deviceUsagePairs  = [[String  = Int]]?
  //    case primaryUsage  = Int?
  //    case primaryUsagePage  = Int?
  //    case uniqueID  = Int
  //  }
  
  var deviceDisplayName : String {
    get {
      let values = [self.manufacturer, self.product].compactMap { $0 }
      return "\(values.joined(separator: ", "))"
    }
  }
  
  var duplicatesDeviceDisplayName : String {
    get {
      let values = [self.manufacturer, self.product, self.serialNumber, String(self.uniqueID)].compactMap { $0 }
      return "\(values.joined(separator: ", "))"
    }
  }
  
  // When updating this, update HidDevice
  var deviceIdentifier : String {
    get {
      //      let values = [self.vendorID, self.product, self.serialNumber].compactMap { String(describing: $0) }
      //      let s = self.serialNumber.map { (val) in String(val) }
      let vendorID = self.vendorID.map { String($0) } ?? ""
      let productID = self.productID.map { String($0) } ?? ""
      let version = self.versionNumber.map { String($0) } ?? ""
      let id = self.serialNumber ?? "\(vendorID),\(productID),\(version)"
      return id
    }
  }
  
  init(device : IOHIDDevice) {
    self.transport      = IOHIDDeviceGetProperty(device, kIOHIDTransportKey as CFString) as? String
    self.vendorID       = IOHIDDeviceGetProperty(device, kIOHIDVendorIDKey as CFString) as? Int
    self.vendorIDSource = IOHIDDeviceGetProperty(device, kIOHIDVendorIDSourceKey as CFString) as? Int
    self.productID      = IOHIDDeviceGetProperty(device, kIOHIDProductIDKey as CFString) as? Int
    self.versionNumber  = IOHIDDeviceGetProperty(device, kIOHIDVersionNumberKey as CFString) as? Int
    self.manufacturer   = IOHIDDeviceGetProperty(device, kIOHIDManufacturerKey as CFString) as? NSString as String?
    self.product        = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString) as? NSString as String?
    self.serialNumber   = IOHIDDeviceGetProperty(device, kIOHIDSerialNumberKey as CFString) as? NSString as String?
    self.countryCode    = IOHIDDeviceGetProperty(device, kIOHIDCountryCodeKey as CFString) as? Int
    self.locationID     = IOHIDDeviceGetProperty(device, kIOHIDLocationIDKey as CFString) as? Int
    self.deviceUsagePairs = IOHIDDeviceGetProperty(device, kIOHIDVendorIDKey as CFString) as? [[String : Int]]
    self.primaryUsage   = IOHIDDeviceGetProperty(device, kIOHIDPrimaryUsageKey as CFString) as? Int
    self.primaryUsagePage = IOHIDDeviceGetProperty(device, kIOHIDPrimaryUsagePageKey as CFString) as? Int
    self.uniqueID       = IOHIDDeviceGetProperty(device, kIOHIDUniqueIDKey as CFString) as! UInt
    
    //    deviceProperties.forEach { (property) in
    //      let propertyVal = IOHIDDeviceGetProperty(device, property as CFString)
    //      guard let value = value1 else { return }
    //      let str = CFValueString(property, value)
    //      let arr = str == nil ? String(describing: CFArrayValues(value)) : nil
    //      //      guard let str = CFValueString(property, value) else { return nil }
    //      return (property, str ?? arr ?? "Unfound")
    //    }
  }
  
  init(deviceStruct d: HidDevice) {
    self.transport = d.transport
    self.vendorID = d.vendorID
    self.vendorIDSource = d.vendorIDSource
    self.productID = d.productID
    self.versionNumber = d.versionNumber
    self.manufacturer = d.manufacturer
    self.product = d.product
    self.serialNumber = d.serialNumber
    self.countryCode = d.countryCode
    self.locationID = d.locationID
    self.deviceUsagePairs = d.deviceUsagePairs
    self.primaryUsage = d.primaryUsage
    self.primaryUsagePage = d.primaryUsagePage
    self.uniqueID = d.uniqueID
  }
}
