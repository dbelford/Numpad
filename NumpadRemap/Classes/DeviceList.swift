//
//  DeviceList.swift
//  NumpadRemap
//
//  Created by David Belford on 9/13/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

//
//  Devices.swift
//  Numpad
//
//  Created by David Belford on 9/13/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation
import IOKit.hid

public let deviceProperties = [
  kIOHIDTransportKey,
  kIOHIDVendorIDKey,
  kIOHIDVendorIDSourceKey,
  kIOHIDProductIDKey,
  kIOHIDVersionNumberKey,
  kIOHIDManufacturerKey,
  kIOHIDProductKey,
  kIOHIDSerialNumberKey,
  kIOHIDCountryCodeKey,
  kIOHIDStandardTypeKey,
  kIOHIDLocationIDKey,
  kIOHIDDeviceUsageKey,
  kIOHIDDeviceUsagePageKey,
  kIOHIDDeviceUsagePairsKey,
  kIOHIDPrimaryUsageKey,
  kIOHIDPrimaryUsagePageKey,
  kIOHIDMaxInputReportSizeKey,
  kIOHIDMaxOutputReportSizeKey,
  kIOHIDMaxFeatureReportSizeKey,
  kIOHIDReportIntervalKey,
  kIOHIDSampleIntervalKey,
  kIOHIDBatchIntervalKey,
  kIOHIDRequestTimeoutKey,
  kIOHIDReportDescriptorKey,
  kIOHIDResetKey,
  kIOHIDKeyboardLanguageKey,
  kIOHIDAltHandlerIdKey,
  kIOHIDBuiltInKey,
  kIOHIDDisplayIntegratedKey,
  kIOHIDProductIDMaskKey,
  kIOHIDProductIDArrayKey,
  kIOHIDPowerOnDelayNSKey,
  kIOHIDCategoryKey,
  kIOHIDMaxResponseLatencyKey,
  kIOHIDUniqueIDKey,
  kIOHIDPhysicalDeviceUniqueIDKey,
  kIOHIDTransportUSBValue,
  kIOHIDTransportBluetoothValue,
  kIOHIDTransportBluetoothLowEnergyValue,
  kIOHIDTransportAIDBValue,
  kIOHIDTransportI2CValue,
  kIOHIDTransportSPIValue,
  kIOHIDTransportSerialValue,
  kIOHIDTransportIAPValue,
  kIOHIDTransportAirPlayValue,
  kIOHIDTransportSPUValue,
  kIOHIDCategoryAutomotiveValue,
]

public let elementProperties = [
  kIOHIDElementKey,
  kIOHIDElementTypeKey,
  kIOHIDElementCollectionTypeKey,
  kIOHIDElementUsageKey,
  kIOHIDElementUsagePageKey,
  kIOHIDElementMinKey,
  kIOHIDElementMaxKey,
  kIOHIDElementScaledMinKey,
  kIOHIDElementScaledMaxKey,
  kIOHIDElementSizeKey,
  kIOHIDElementReportSizeKey,
  kIOHIDElementReportCountKey,
  kIOHIDElementReportIDKey,
  kIOHIDElementIsArrayKey,
  kIOHIDElementIsRelativeKey,
  kIOHIDElementIsWrappingKey,
  kIOHIDElementIsNonLinearKey,
  kIOHIDElementHasPreferredStateKey,
  kIOHIDElementHasNullStateKey,
  kIOHIDElementFlagsKey,
  kIOHIDElementUnitKey,
  kIOHIDElementUnitExponentKey,
  kIOHIDElementNameKey,
  kIOHIDElementValueLocationKey,
  kIOHIDElementDuplicateIndexKey,
  kIOHIDElementParentCollectionKey,
  kIOHIDElementVariableSizeKey,
  kIOHIDElementVendorSpecificKey,
  kIOHIDElementCookieMaxKey,
  kIOHIDElementUsageMinKey,
  kIOHIDElementUsageMaxKey,
  kIOHIDElementVendorSpecificKey
]

struct HidDevice {
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
  var uniqueID : Int?
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
    self.uniqueID       = IOHIDDeviceGetProperty(device, kIOHIDUniqueIDKey as CFString) as? Int

//    deviceProperties.forEach { (property) in
//      let propertyVal = IOHIDDeviceGetProperty(device, property as CFString)
//      guard let value = value1 else { return }
//      let str = CFValueString(property, value)
//      let arr = str == nil ? String(describing: CFArrayValues(value)) : nil
//      //      guard let str = CFValueString(property, value) else { return nil }
//      return (property, str ?? arr ?? "Unfound")
//    }

  }
}

public func CFDictionaryValues(_ value: CFTypeRef) -> String? {
  switch CFGetTypeID(value) {
  case CFDictionaryGetTypeID():
    let d = value as! CFDictionary
    let d2 = d as NSDictionary
    return String(describing: d2)
  default:
    return nil
  }
}

public func CFArrayValues(_ value: CFTypeRef) -> [String]? {
  switch CFGetTypeID(value) {
  case CFArrayGetTypeID():
    let arr = value as! [CFTypeRef]
    var newValues = [String]()
    for v in arr {
      if let s = CFValueString("", v) {
        newValues.append(s)
      } else {
        return nil
      }
    }
    return newValues
  default:
    return nil
  }
}

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
    return "Did not match CFTypeID"
  }
}


enum CFValue {
  indirect case dictionary([String: CFValue])
  case string(String)
  
  var value: CFValue {
    switch self {
    case .string(let str): return CFValue.string(str)
    case .dictionary(let dict):
      var r = [String : CFValue]()
      for (k, val) in dict {
        r[k] = val.value
      }
      return .dictionary(r)
    }
  }
  
  func printed() -> Any {
    var out = [String : Any]()
    var out2 : String?
    switch self {
    case .string(let str): out2 = str
    case .dictionary(let dict):
      out = dict.mapValues { (val) -> Any in
        return val.printed()
      }
    }
    if let out2 = out2 {
      return out2
    } else {
      return out
    }
  }
}

//public func CFDictionaryStrings(_ value: CGPDFDictionaryRef) -> [String: CFDictionary]

class DevicesList {
  var manager : IOHIDManager?
  var deviceList : [[String : String]]
  var devices : [HidDevice]

  init() {
    deviceList = []
    devices = []
    self.start()
  }
  
  func start() {
    let manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    
    //IOHIDManagerSetDeviceMatching(manager, nil)
    let d : CFDictionary = [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
    let k : CFDictionary = [kIOHIDDeviceUsagePageKey: kHIDPage_KeyboardOrKeypad, kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
    //let k : CFDictionary = [kIOHIDDeviceUsagePageKey: kHIDPage_Undefined, kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
    
    IOHIDManagerSetDeviceMatching(manager, d)
    let devices = IOHIDManagerCopyDevices(manager)
    if let devices = devices as? Set<IOHIDDevice> {
      for device in devices {
        self.devices.append(self.getDevice(device: device))
        deviceList.append(getProperties(device: device))
      }
    }
    
    // TODO: NEED TO DESTROY MANAGER when DeviceList done, otherwise callback still exist
    
    IOHIDManagerRegisterInputValueCallback(manager, { (context, result, sender, device) in
      if let context = context {
        let list = Unmanaged<DevicesList>.fromOpaque(context).takeRetainedValue()
        print("Pointer matched in inputvalue callback \(list)")
      }
    }, Unmanaged<DevicesList>.passUnretained(self).toOpaque())
    IOHIDManagerRegisterDeviceRemovalCallback(manager, { (context, result, sender, device) in
      if let context = context {
        let list = Unmanaged<DevicesList>.fromOpaque(context).takeRetainedValue()
        print("Pointer matched in removal callback \(list)")
      }
    }, Unmanaged<DevicesList>.passUnretained(self).toOpaque())
    IOHIDManagerRegisterDeviceMatchingCallback(manager, {(context : UnsafeMutableRawPointer?,
                                                           result : IOReturn,
                                                           sender : UnsafeMutableRawPointer?,
                                                           device : IOHIDDevice) in
      if let context = context {
        let list = Unmanaged<DevicesList>.fromOpaque(context).takeRetainedValue()
        print("Pointer matched in matchingcallback \(list)")
      }
      
      if result == kIOReturnSuccess {
        dump(device)
        print("Match Success")
      } else {
        print("Match failed")
      }
    }, Unmanaged<DevicesList>.passUnretained(self).toOpaque())
    IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    IOHIDManagerOpen(manager, 0)

  }
  
  deinit {
    if let manager = self.manager {
      IOHIDManagerClose(manager, 0)
      
    }
  }
  
  func handleMatching(_ context : UnsafeMutableRawPointer?, _ result : IOReturn, _ sender : UnsafeMutableRawPointer?, _ device : IOHIDDevice) -> Swift.Void {
    if result == kIOReturnSuccess {
      dump(device)
      print("Match Success")
    } else {
      print("Match failed")
    }
  }
  
  public func getDevice(device : IOHIDDevice) -> HidDevice {
    return HidDevice(device: device)
  }
  
  public func getProperties(device : IOHIDDevice) -> [String : String] {
    var properties = [String : String]()
    let description = deviceProperties.compactMap{ (property) -> (String, String)? in
      let value1 = IOHIDDeviceGetProperty(device, property as CFString)
      guard let value = value1 else { return nil }
      let str = CFValueString(property, value)
      let arr = str == nil ? String(describing: CFArrayValues(value)) : nil
//      guard let str = CFValueString(property, value) else { return nil }
      return (property, str ?? arr ?? "Unfound")
    }
    description.forEach( { pair in
        let (property, value) = pair
        properties[property] = value
    })
    return properties
  }
  
  public func deviceDescription(_ device : IOHIDDevice ) -> String {
    
    //    kIOHIDLocationIDKey,kIOHIDSerialNumberKey,kIOHIDManufacturerKey,kIOHIDVendorIDKey,kIOHIDProductIDKey
    let product = IOHIDDeviceGetProperty(device, kIOHIDProductIDKey as CFString) as? Int
    let vendor = IOHIDDeviceGetProperty(device, kIOHIDVendorIDKey as CFString) as? Int
    let manufacturer = IOHIDDeviceGetProperty(device, kIOHIDManufacturerKey as CFString) as? String
    let serialNumber = IOHIDDeviceGetProperty(device, kIOHIDSerialNumberKey as CFString) as? String
    let location = IOHIDDeviceGetProperty(device, kIOHIDLocationIDKey as CFString) as? Int
    //    let v = vendor?.intValue
    //    let
    let vendorS = vendor != nil ? String(vendor!) : ""
    let productS = product != nil ? String(product!) : ""
    let locationS = location != nil ? String(location!) : ""
    return "\(vendorS), \(productS), \(manufacturer ?? ""), \(serialNumber ?? "" ), \(locationS)  "
    //    if let product = product as? String { }
    //    return
  }
}
