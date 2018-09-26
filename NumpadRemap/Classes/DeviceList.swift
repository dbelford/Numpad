//
//  DeviceList.swift
//  NumpadRemap
//
//  Created by David Belford on 9/13/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation
import IOKit.hid

protocol DeviceListDelegate {
  func devicesChanged()
  func deviceMatches(devices: DeviceList)
  func deviceRemoval(devices: DeviceList)
  func deviceValueChanged(devices: DeviceList)
}

class DeviceList {
  var manager : IOHIDManager?
  var devices : [UInt : HidDevice]
  var delegate : DeviceListDelegate?

  init() {
    devices = [:]
    self.start()
  }
  
  func start() {
    self.manager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone))
    guard let manager = self.manager else {
      print("Failed to start device manager")
      return
    }
    //IOHIDManagerSetDeviceMatching(manager, nil)
    let d : CFDictionary = [kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop, kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
    let k : CFDictionary = [kIOHIDDeviceUsagePageKey: kHIDPage_KeyboardOrKeypad, kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
    //let k : CFDictionary = [kIOHIDDeviceUsagePageKey: kHIDPage_Undefined, kIOHIDDeviceUsageKey: kHIDUsage_GD_Keyboard] as CFDictionary
    
    IOHIDManagerSetDeviceMatching(manager, d)
    let devices = IOHIDManagerCopyDevices(manager)
    if let devices = devices as? Set<IOHIDDevice> {
      for device in devices {
        let d = HidDevice(device: device)
        self.devices[d.uniqueID] = d
      }
    }
    
    IOHIDManagerRegisterInputValueCallback(manager, { (context, result, sender, value) in
      if let context = context {
        let weakSelf = Unmanaged<DeviceList>.fromOpaque(context).takeUnretainedValue()
        weakSelf.delegate?.deviceValueChanged(devices: weakSelf)
        
        if result == kIOReturnSuccess {
          //        dump(sender)
          //        dump(value)
          let el = IOHIDValueGetElement(value)
          let usage = IOHIDElementGetUsage(el) //Scancode
          guard (usage >= 4 && usage <= 231) else { return }
          let usagePage = IOHIDElementGetUsagePage(el)
          let intVal = IOHIDValueGetIntegerValue(value)
          let timestamp = IOHIDValueGetTimeStamp(value)
          //        let name = IOHIDElementGetName(el)
          //        let _ = IOHIDELementget
          let dev = IOHIDElementGetDevice(el)
          let hid = HidDevice(device: dev)
          let description = hid.duplicatesDeviceDisplayName
          print(description)
//          lastDevice = deviceDescription(dev)
          
          //        guard let locationP = IOHIDDeviceGetProperty(dev, kIOHIDLocationIDKey as CFString) else { return }
          //        guard let location = locationP as? Int else { return }
          //
          //        let unit = IOHIDElementGetUnit(el)
          //        if intVal == 0 {
          ////            guard let device = deviceKeySets[location] else { return }
          //            guard let keyupKey = deviceKeySets[location]?.removeValue(forKey: usage) else { return }
          ////            let keyupKey = device.removeValue(forKey: usage)
          //            depressedKeysByTimestamp[timestamp] = keyupKey
          //        } else {
          //            let description = deviceDescription(dev)
          //            let s = Key(timeStamp: timestamp, HIDCode: usage, deviceLocation: 0, description: description as CFString)
          //            if (deviceKeySets[location] == nil) {
          //                deviceKeySets[location] = KeySet()
          //            }
          //            deviceKeySets[location]?[usage] = s
          //        }
          
          //        CGEvent.getIntegerValueField(<#T##CGEvent#>)
          //        UCKeyTranslate()
          //        let _ = IOHIDValueGet
          
          
          //        print(hidKeyForCode(Int(usage)) ?? "No key found", usagePage, intVal, timestamp, unit)
          //        printAllProperties(element: el)
          //        printAllProperties(device: dev)
          
          //        let el = IOHIDValueGetElement(value)
          //        dump(el)
          print("Value received")
        } else {
          print("Value failed")
        }
        
      }
    }, Unmanaged<DeviceList>.passUnretained(self).toOpaque())
    
    IOHIDManagerRegisterDeviceRemovalCallback(manager, { (context, result, sender, device) in
      if let context = context {
        let weakSelf = Unmanaged<DeviceList>.fromOpaque(context).takeUnretainedValue()
        let hid = HidDevice(device: device)
        weakSelf.devices.removeValue(forKey: hid.uniqueID)
        weakSelf.delegate?.deviceRemoval(devices: weakSelf)
      }
    }, Unmanaged<DeviceList>.passUnretained(self).toOpaque())
    
    IOHIDManagerRegisterDeviceMatchingCallback(manager, {(context : UnsafeMutableRawPointer?,
                                                           result : IOReturn,
                                                           sender : UnsafeMutableRawPointer?,
                                                           device : IOHIDDevice) in
      if let context = context {
        let weakSelf = Unmanaged<DeviceList>.fromOpaque(context).takeUnretainedValue()
        let hid = HidDevice(device: device)
        weakSelf.devices[hid.uniqueID] = hid
        weakSelf.delegate?.deviceMatches(devices: weakSelf)
      }
      
      if result == kIOReturnSuccess { } else { } // Not sure what IOReturn values can happen here...
    }, Unmanaged<DeviceList>.passUnretained(self).toOpaque())
    IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    IOHIDManagerOpen(manager, 0)
  }
  
  deinit {
    if let manager = self.manager {
      IOHIDManagerClose(manager, 0)
    }
  }
}
