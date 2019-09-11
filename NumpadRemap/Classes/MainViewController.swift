//
//  MainViewController.swift
//  Numpad
//
//  Created by David Belford on 8/14/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

class MainViewController : NSViewController, DeviceListDelegate {
  var preferences : NRPreferences?


  lazy var smallMenu = { () -> NSMenu in
    let m = NSMenu(title: "Action Menu")
    let items = [
      ("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:)), ""),
      ("Preferences", #selector(MainViewController.tryPreferences(_:)), ""),
      ("Quit", #selector(NSApplication.terminate(_:)), "")
    ]
    for (title, action, keyEquivalent) in items {
      m.addItem(NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent))
    }
    m.insertItem(NSMenuItem.separator(), at: items.count - 1)
    return m
  }()
  
  @IBOutlet var actionMenu : NSMenu!
  @IBAction func tryTodos(_ sender: NSMenuItem) {
    NSWorkspace.shared().openFile("/Users/dbelford/Projects/osx.launchpad-remap/TODO.txt", withApplication: "Sublime Text 3.app")
  }
  @IBAction func tryQuit(_ sender: NSMenuItem) {
    NSRunningApplication.current().terminate()
  }
  @IBAction func tryAbout(_ sender: NSMenuItem) {}
  @IBAction func tryPreferences(_ sender: NSMenuItem) {
    self.doCommand(by: #selector(NRAppDelegate.showPreferencesWindow))
  }
  @IBAction func showMenu(_ sender : NSButton) {
    if let menu = sender.menu, let event = NSApplication.shared().currentEvent {
      NSMenu.popUpContextMenu(menu, with: event, for: sender)
    }
    
  }
  
  init?(preferences: NRPreferences) {
    super.init(nibName: nil, bundle: nil)
    self.setup(preferences: preferences)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.setup(preferences: NRPreferences.sharedInstance())
  }
  
  override func loadView() {
    let mainView = NRWindowContentView(frame: NSMakeRect(0, 0, 400, 400))
    self.view = mainView
  }
  
  func addFontButton() {

    let b = FontAwesomeButton(frame: NSMakeRect(0, 0, 26, 26))
    self.view.addSubview(b)
    b.isPadded = true
    b.isSquare = true
    b.size = 20
    b.strokeWidth = 0
    b.edgeInsets = NIKEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
    b.edgeInsetTop = 7
    b.bezelStyle = NSBezelStyle.regularSquare
    b.isBordered = true
    b.translatesAutoresizingMaskIntoConstraints = false
    b.wantsLayer = true
    b.iconHex = "f013" // Setting this earlier breaks
    
    NSLayoutConstraint.activate([
      b.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -7),
      b.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 7),
      b.widthAnchor.constraint(equalToConstant: 28),
      b.heightAnchor.constraint(equalToConstant: 28)
    ])
    b.menu = self.smallMenu
    b.action = #selector(MainViewController.showMenu(_:))
    b.sizeToFit()
    
  }
  
  // MARK: DeviceList & Delegate Methods
  var deviceListObservers : [NotificationToken]?
  lazy var devices : DeviceList = {
    let l = DeviceList()
    l.addDelegate(self)
    self.deviceListObservers = [
      NotificationCenter.default.observe(name: NSNotification.Name.DeviceList.Addition, object: l, queue: nil, using: { [weak self, weak l](n) in
        guard let weakSelf = self, let l = l else { return }
        self?.deviceAddition(devices: l)
      }),
      NotificationCenter.default.observe(name: NSNotification.Name.DeviceList.Removal, object: l, queue: nil, using: { [weak self, weak l](n) in
        guard let weakSelf = self, let l = l else { return }
        self?.deviceRemoval(devices: l)
      }),
      NotificationCenter.default.observe(name: NSNotification.Name.DeviceList.Value, object: l, queue: nil, using: { [weak self, weak l](n) in
        guard let weakSelf = self, let l = l else { return }
        self?.deviceValueChanged(devices: l)
      })
    ]
    return l
  }()
  
  func deviceRemoval(devices: DeviceList) {
    self.updateDevicesMenu()
  }
  
  func deviceAddition(devices: DeviceList) {
    self.updateDevicesMenu()
  }
  
  
  // MARK: Devices Menu
  
  var preferencesObserver : NSKeyValueObservation?
  lazy var deviceMenu : NSMenu = {
    return NSMenu(title: "Keyboard Select")
  }()
  lazy var deviceDropdownButton : NSPopUpButton = {
    let dropdown = NSPopUpButton(frame: NSZeroRect, pullsDown: false)
    dropdown.menu = self.deviceMenu
//    dropdown.setButtonType(NSButtonType.pop)
    dropdown.selectItem(at: 0)
    dropdown.synchronizeTitleAndSelectedItem()
    dropdown.isBordered = false
    dropdown.target = self
    dropdown.action = #selector(selectDevice(sender:))
    dropdown.translatesAutoresizingMaskIntoConstraints = false
    dropdown.sizeToFit()
    return dropdown
  }()
  
  func addDevicesMenu() {
    self.updateDevicesMenu()
    self.preferencesObserver = self.preferences?.observe(\NRPreferences.presentedDevice, changeHandler: { [weak self] (preferences, change) in
      self?.updateDevicesMenu()
    })
    self.view.addSubview(self.deviceDropdownButton)
    self.deviceDropdownButton.sizeToFit()
    NSLayoutConstraint.activate([
      self.deviceDropdownButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 7),
      self.deviceDropdownButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 7),
      //      dropdown.trailingAnchor.constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutXAxisAnchor>#>, constant: <#T##CGFloat#>)
      //      dropdown.widthAnchor.constraint(equalToConstant: 148),
      self.deviceDropdownButton.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
      self.deviceDropdownButton.heightAnchor.constraint(equalToConstant: 28)
      ])
  }
  
  
  func updateDevicesMenu() {
    self.deviceMenu.removeAllItems()
    self.devices.devices.forEach { (key, value) in
      let item = NSMenuItem(title: value.deviceDisplayName, action: nil, keyEquivalent: "")
      item.identifier = value.deviceIdentifier
      item.tag = Int(value.uniqueID) // FIXME: Probably don't do this... Maybe create menu from Represented Object
      self.deviceMenu.addItem( item )
    }
    self.updatePresentedDevice()
  }

  func selectMenuItemForIdentifier(identifier: String) {
    guard let (uuid, device) = self.devices.deviceForIdentifier(identifier: identifier) else {
      return
    }

    let menuItemIndex = self.deviceDropdownButton.indexOfItem(withTag: Int(uuid))
    let menuItem = self.deviceDropdownButton.item(at: menuItemIndex)
    if menuItem != nil && menuItem?.identifier == device.deviceIdentifier {
      debugPrint(menuItemIndex)
      self.deviceDropdownButton.selectItem(at: menuItemIndex)
      self.deviceDropdownButton.synchronizeTitleAndSelectedItem()
      self.deviceDropdownButton.sizeToFit()
    } else {
      debugPrint("Need to fix code if reaching here.")
    }
  }
  
  func updatePresentedDevice() {
    if let presentedDeviceIdentifier = self.preferences?.presentedDevice as String?  {
      self.selectMenuItemForIdentifier(identifier: presentedDeviceIdentifier)
    } else if let identifier = self.deviceDropdownButton.selectedItem?.identifier as NSString? {
       self.preferences?.presentedDevice = identifier
    } else {
      debugPrint("No presented device set.")
    }
  }
  
  func selectDevice(sender: NSPopUpButton) {
    
    guard let identifier = sender.selectedItem?.identifier as NSString? else { return }
    DispatchQueue.main.async() {
      self.preferences?.presentedDevice = identifier
    }
  }
  
  //MARK: Settings Menu
  
  func settingsMenu() {


    let c = NSMenu(title: "Config")

////    let configs = getConfigs
//    let configsMenuItems = configs.map { config -> NSMenuItem in
//
//    }

    let configsForKeyboard = [
      NSMenuItem(title: "Default", action: #selector(MainViewController.selectConfig), keyEquivalent: ""),
      NSMenuItem(title: "New Keyboard Preferences", action: #selector(MainViewController.newKeyboardPreference), keyEquivalent: "")
    ]
    for config in configsForKeyboard {
      c.addItem(config)
    }
  }
  
  func selectConfig() {
    
  }
  
  func newKeyboardPreference() {
    
  }
  
  func setup(preferences: NRPreferences) {
    self.preferences = preferences
    let model = ShortcutMappingModel(preferences: preferences)
    let vm = NumpadViewModel(model: model)
    let numpadViewController = NumpadViewController(viewModel: vm, model: model)
    if let numpadViewController = numpadViewController {
      self.addChildViewController(numpadViewController)
      if let v = self.childViewControllers.first?.view {
        self.view.addSubview(v)
        let inset : CGFloat = 3.0 // 3 because keyview inset 4 on a side: 3 + 4 = 7
        NSLayoutConstraint.activate([
          v.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 7.0 + 28.0 + inset),
          v.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -inset),
          v.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: inset),
          v.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -inset)
          ])
      }
      self.addFontButton()
      self.addDevicesMenu()
    }
  }
  
  
}
