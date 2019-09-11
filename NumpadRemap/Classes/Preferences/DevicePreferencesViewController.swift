//
//  DevicePreferencesViewController.swift
//  Numpad
//
//  Created by David Belford on 9/27/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

@objc
class DeviceRow : NSObject {
  var device : HidDeviceObject
  var keyboardTypes : [String] = KeyboardTypes.allRawValues
  var bindingTypes : [String] = AppBindingStyle.allRawValues
  var selectedKeyboardType : String
  var selectedBindingType : String
  var preferences : NRPreferences
  var observers : [NSKeyValueObservation] = [NSKeyValueObservation]()
  
  init(device : HidDeviceObject, preferences : NRPreferences) {
    self.device = device
    self.preferences = preferences
    self.selectedKeyboardType = KeyboardTypes.numpad.rawValue
    self.selectedBindingType = AppBindingStyle.Recency.rawValue
    super.init()
    self.observers.append(
      self.preferences.observe(\NRPreferences.keyboardType, changeHandler: { [weak self] (preferences, change) in
        guard let keyboardType = self?.preferences.keyboardType else { return }
        self?.selectedKeyboardType = KeyboardTypes(keyboardType).rawValue
      })
    )
    self.observers.append(
      self.observe(\DeviceRow.selectedKeyboardType) { [weak self](row, change) in
        guard let weakSelf = self else { return }
        guard let keyboard = KeyboardTypes(rawValue: weakSelf.selectedKeyboardType) else { return }
        self?.preferences.keyboardType = keyboard.nrKeyboardType()
      }
    )
  }
}

class KeyboardValueTranformer : ValueTransformer {
  
}

@objc
class DevicePreferencesViewController : NRPreferencesViewController, MASPreferencesViewController, NSTableViewDelegate {
  var viewIdentifier: String = "Devices"
  var deviceListObservers : [NotificationToken]?
  var preferencesObserver : NSKeyValueObservation?
  @IBOutlet var devices : NSArrayController? = NSArrayController(content: nil)
  @IBOutlet var keyboardTypesSelected : NSNumber? = 0
  @IBOutlet var keyboardTypesArr = KeyboardTypes.allRawValues
  @IBOutlet var arrayController : NSArrayController?
  @IBOutlet var keyboardTypes : NSArrayController? = NSArrayController(content: KeyboardTypes.allRawValues)
  @IBOutlet var appBindingStylesSelected : NSNumber? = nil
  @IBOutlet var appBindingStyles : NSArrayController? = NSArrayController(content: AppBindingStyle.allRawValues)
  @IBOutlet var tableView : NSTableView?
  @IBOutlet var rowData : NSArrayController? = NSArrayController(content: nil)
  var deviceList : DeviceList?
//  var identifier: String? = "Devices"
  
  var toolbarItemLabel: String? = NSLocalizedString("Devices", comment: "Device pane title")
  var toolbarItemImage: NSImage? = NSImage(named: NSImage.Name.listViewTemplate)
  
  convenience init?(deviceList: DeviceList) {
    self.init(nibName: NSNib.Name(rawValue: "DevicePreferencesViewController"), bundle: nil)
    self.preferencesObserver = self.preferences?.observe(\NRPreferences.presentedDevice, changeHandler: { [weak self] (preferences, change) in
      guard let identifier = self?.preferences.presentedDevice as String? else { return }
      let devices = self?.devices?.content as? [HidDeviceObject]
      guard let d = devices?.first(where: { (device) -> Bool in
        return device.deviceIdentifier == identifier
      }) else { return }
      self?.devices?.setSelectedObjects([d])
    })
    self.deviceList = deviceList
    self.deviceListObservers = [
      NotificationCenter.default.observe(name: NSNotification.Name.DeviceList.Removal, object: self.deviceList, queue: nil, using: { [weak self](notification) in
        self?.updateDevices()
      }),
      NotificationCenter.default.observe(name: NSNotification.Name.DeviceList.Addition, object: self.deviceList, queue: nil, using: { [weak self](notification) in
        self?.updateDevices()
      })
    ]
    self.updateDevices()
    self.keyboardTypes?.content = KeyboardTypes.allRawValues
//    let devices = self.deviceList?.devices.map { (uuid, device) -> HidDeviceObject in
//      return HidDeviceObject(deviceStruct: device)
//    }
//    self.devices?.content = devices
  }
  
  override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateDevices() {
    self.keyboardTypes?.content = KeyboardTypes.allRawValues
    let selected = self.devices?.selectedObjects.first as? HidDeviceObject
    let devices = self.deviceList?.devices.map { (uuid, device) -> HidDeviceObject in
      return HidDeviceObject(deviceStruct: device)
    }
    let r = self.deviceList?.devices.map { (uuid, device) -> DeviceRow in
      return DeviceRow(device: HidDeviceObject(deviceStruct: device), preferences: preferences)
//      var row : NSMutableDictionary
//      row = [
//        "device" : HidDeviceObject(deviceStruct: device),
//        "keyboardTypes" : KeyboardTypes.allRawValues,
//        "bindingTypes" : AppBindingStyle.allRawValues,
//        "selectedKeyboardType" : KeyboardTypes.numpad.rawValue,
//        "selectedBindingType" : AppBindingStyle.Recency.rawValue
//        ]
//      return row
    }
    self.rowData?.content = r
    self.devices?.content = devices

    if let selected = selected {
      let d = devices?.first(where: { (device) -> Bool in
        return device.deviceIdentifier == selected.deviceIdentifier
      })
      if let d = d {
        self.devices?.setSelectedObjects([d])
      }
    }
    //self.tableView?.reloadData()
//    self.devices?.setSelectedObjects(<#T##objects: [Any]##[Any]#>)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.identifier = NSUserInterfaceItemIdentifier(rawValue: "Devices")
    self.tableView?.delegate = self
  }
  
  func tableViewSelectionDidChange(_ notification: Notification) {
    let o = self.devices?.selectedObjects.first as? HidDeviceObject
    if let o = o {
      self.preferences.presentedDevice = o.deviceIdentifier as NSString
      
    }
  }
  
  //MARK: IBActions
  
//  @IBOutlet var keyboardTypes : [String]? = KeyboardTypes.allRawValues
  @IBAction func selectKeyboardType(_ sender: NSPopUpButton) {
    //self.preferences.keyboardType = KeyboardTypes
  }
  
  @IBAction func selectBindingStyle(_ sender: NSPopUpButton) {
    
  }
//  @IBOutlet var appBindingStypes : [String]? = AppBindingStyle.allRawValues
  
}
