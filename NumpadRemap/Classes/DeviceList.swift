//
//  DeviceList.swift
//  NumpadRemap
//
//  Created by David Belford on 9/13/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation
import IOKit.hid

protocol DeviceListDelegate: AnyObject {
  
}

typealias DeviceAdditionCallback = () -> Void
typealias DeviceRemovalCallback = () -> Void
typealias DeviceValueCallback = () -> Void

protocol DeviceListInterface {
  func onDeviceMatches(_ callback: @escaping DeviceAdditionCallback)
  func onDeviceRemoval(_ callback: @escaping DeviceRemovalCallback)
  func onDeviceValue(_ callback: @escaping DeviceValueCallback)
}

extension DeviceListDelegate {
  func devicesChanged() {}
  func deviceAddition(devices: DeviceList)  {}
  func deviceRemoval(devices: DeviceList)  {}
  func deviceValueChanged(devices: DeviceList)  {}
}


typealias HidUUID = UInt

public extension Notification.Name {
  public struct DeviceList {
    public static let Addition = Notification.Name("com.dbelford.notification.name.devicelist.addition")
    public static let Removal = Notification.Name("com.dbelford.notification.name.devicelist.removal")
    public static let Value = Notification.Name("com.dbelford.notification.name.devicelist.value")
  }
}

extension Notification {
  public struct Key {
    public static let Data = "com.dbelford.notification.key.data"
  }
}

struct DeviceListNotifications {
  let Matching  = "DeviceListMatching"
  let Removal   = "DeviceListRemoval"
  let Value     = "DeviceListValue"
}

class DeviceList {
  var manager : IOHIDManager?
  var devices : [HidUUID : HidDevice]
  var delegates : [DeviceListDelegate] = []

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
//        weakSelf.delegate?.deviceValueChanged(devices: weakSelf)
//        weakSelf.invokeDeviceValueCallbacks()
//        weakSelf.notifyValueChanged()
        NotificationCenter.default.post(name: Notification.Name.DeviceList.Value, object: weakSelf, userInfo: [Notification.Key.Data: "keyvlaueGoesHere"])
        
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
          print("Value received \(usage)")
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
//        weakSelf.delegate?.deviceRemoval(devices: weakSelf)
//        weakSelf.invokeDeviceRemovalCallbacks()
//        weakSelf.notifyDeviceRemoval()
        NotificationCenter.default.post(name: Notification.Name.DeviceList.Removal, object: weakSelf, userInfo: [Notification.Key.Data: "removedDeviceGoesHere"])
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
//        weakSelf.delegate?.deviceMatches(devices: weakSelf)
//        weakSelf.invokeDeviceMatchesCallbacks()
//        weakSelf.notifyDeviceMatch()
        NotificationCenter.default.post(name: Notification.Name.DeviceList.Addition, object: weakSelf, userInfo: [Notification.Key.Data: "added/matchingDeviceGoesHere"])
      }
      
      if result == kIOReturnSuccess { } else { } // Not sure what IOReturn values can happen here...
    }, Unmanaged<DeviceList>.passUnretained(self).toOpaque())
    IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    IOHIDManagerOpen(manager, 0)
  }

  
  func deviceForIdentifier(identifier: String) -> (HidUUID, HidDevice)? {
    return self.devices.first { (uuid, device) -> Bool in
      return device.deviceIdentifier == identifier
    }
  }
  
  deinit {
    if let manager = self.manager {
      IOHIDManagerClose(manager, 0)
      // Do I need to remove IOHIDManager from runloop or does close do this?
      // Should there be separate start/stop/cleanup methods?
    }
  }
  
  //MARK: Delegates
  
  func addDelegate(_ delegate : DeviceListDelegate) {
    self.delegates.append(delegate)
  }
  
  func removeDelegate(_ adel : DeviceListDelegate) {

    let idx = self.delegates.index{ (del) -> Bool in
      return adel === del
    }
    guard let index = idx else { return }
    self.delegates.remove(at: index)
  }
  
  func notifyDeviceMatch() { for delegate in self.delegates { delegate.deviceAddition(devices: self) }}
  func notifyDeviceRemoval() { for delegate in self.delegates { delegate.deviceRemoval(devices: self) }}
  func notifyValueChanged() { for delegate in self.delegates { delegate.deviceValueChanged(devices: self) }}

}
