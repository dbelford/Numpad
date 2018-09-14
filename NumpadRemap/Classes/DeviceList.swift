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
  kIOHIDElementVendorSpecificKey
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
  kIOHIDElementUsageMaxKey
]

public func CFValueString(_ property: String, _ value: CFTypeRef) -> String? {
  switch CFGetTypeID(value) {
  case CFStringGetTypeID():
    guard let s = value as? String else { return nil }
    return "\(property): \(s)"
  case CFNumberGetTypeID():
    guard let n = value as? NSNumber else { return nil }
    return "\(property): \(n.stringValue)"
  case CFDictionaryGetTypeID():
    //        guard let v = value as? NSDictionary else { return nil }
    return "\(property): CFDictionary Print Implementation"
  case CFArrayGetTypeID():
    //                guard let v = value as? NSArray else { return nil }
    return "\(property): CFArray Print Implementation"
  case CFSetGetTypeID():
    //        guard let v = value as? NSSet else { return nil }
    return "\(property): CFSet Print Implementation"
  case CFBooleanGetTypeID():
    return "\(property): CFBool Print Implementation"
  default:
    return "\(property): Did not match CFTypeID"
  }
}

class DevicesList {
  var manager : IOHIDManager?
  var deviceList : [[String : String]]
  
  init() {
    deviceList = []
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
        deviceList.append(getProperties(device: device))
      }
    }
  }
  
  public func getProperties(device : IOHIDDevice) -> [String : String] {
    var properties = [String : String]()
    let description = deviceProperties.compactMap{ (property) -> (String, String)? in
      let value1 = IOHIDDeviceGetProperty(device, property as CFString)
      guard let value = value1 else { return nil }
      guard let str = CFValueString(property, value) else { return nil }
      return (property, str)
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
