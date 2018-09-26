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
    
    IOHIDManagerRegisterInputValueCallback(manager, { (context, result, sender, device) in
      if let context = context {
        let weakSelf = Unmanaged<DeviceList>.fromOpaque(context).takeUnretainedValue()
        weakSelf.delegate?.deviceValueChanged(devices: weakSelf)
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
