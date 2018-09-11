//
//  NumpadViewController.swift
//  Numpad
//
//  Created by David Belford on 8/14/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

class NumpadViewController : NSViewController {
  @IBOutlet var numpadModel : ShortcutMappingModel?
  @IBOutlet var numpadViewModel : NumpadViewModel?
  @IBOutlet var numpadView : ExpandedNumpadView? {
    didSet {
      if let numpadView = numpadView {
        self.view = numpadView
        //        self.view.isHidden = true
      }
    }
  }
  override var acceptsFirstResponder: Bool { return true }
  var monitor : DABActiveApplicationsMonitor?;
  var appList : [URL]?;
  
  //  required init?(coder: NSCoder) {
  //    return super.init(coder: coder)
  //  }
  
  // MARK: - Responding to Key Presses
  
  override func keyDown(with event: NSEvent) {
    if ( !self.handleNumpadKeypress(with: event.keyCode) ) {
      super.keyDown(with: event)
    }
  }
  
  func handleNumpadKeypress(with keyCode : UInt16 ) -> Bool {
//    let order = NRPreferences.sharedInstance().keyOrdering
//    let appIndex = NRNumpadModel.index(forKeyCode: keyCode, using: order)
//    guard appIndex != NSNotFound  else {
//      return false
//    }
//    self.numpadModel?.launchApplication(at: appIndex)
//    return self.numpadModel?.launchApplication(forKeycode: UInt(keyCode)) ?? false
    return self.numpadModel?.launchApplication(keyCode: UInt(keyCode)) ?? false
  }
  
  
  // MARK: - Configure Controller
  
  init?(viewModel: NumpadViewModel, model: ShortcutMappingModel) {

    super.init(nibName: nil, bundle: nil)
    self.numpadViewModel = viewModel
    self.numpadModel = model

    MASShortcutBinder.shared().bindShortcut(withDefaultsKey: kAppActivationShortcutKey) { [weak self] in
      self?.numpadModel?.launchApplication(runningApplication: NSRunningApplication.current())
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //    self.configurePreferencePane()
    //    self.configureConstraints()
    //    self.prefView.removeFromSuperview()
    //    self.numpadModel = NRNumpadModel.init()
    //self.numpadView = NRNumpadView.init() // TODO: This goes here? init maybe?
    
//    self.numpadView = ExpandedNumpadView.init(frame: NSMakeRect(0, 0, 50, 50))
//    //    self.numpadView.viewModel = NRNumpadViewModel.init(model: self.numpadModel)
//    self.numpadView?.viewModel = self.numpadViewModel;
//    self.numpadView?.viewModel?.onPressedKeyForKeycode(handler: { [weak self] (keyCode) in
////      guard let strongSelf = self else { return }
//      guard let keyCodeN = keyCode as? NSNumber else { return }
//      _ = self?.handleNumpadKeypress(with: keyCodeN.uint16Value)
//    })
    
//    self.numpadView?.viewModel?.keycodeActivatedSignal.subscribeNext { [weak self] keyCode in
//      guard let strongSelf = self else { return }
//      guard let keyCodeN = keyCode as? NSNumber else { return }
//      _ = strongSelf.handleNumpadKeypress(with: keyCodeN.uint16Value)
//    }
    MASShortcutBinder.shared().bindShortcut(withDefaultsKey: kAppActivationShortcutKey) { [weak self] in
//      guard let strongSelf = self else { return }
//      strongSelf.numpadModel?.launch(NSRunningApplication.current())
      self?.numpadModel?.launchApplication(runningApplication: NSRunningApplication.current())
    }
  }
  
  override func loadView() {
//    super.loadView()
    if self.nibName == nil {
      
    }
    self.numpadView = ExpandedNumpadView.init(frame: NSMakeRect(0, 0, 50, 50))
    self.numpadView?.viewModel = self.numpadViewModel;
    self.numpadView?.viewModel?.onPressedKeyForKeycode(handler: { [weak self] (keyCode) in
      guard let keyCodeN = keyCode as? NSNumber else { return }
      _ = self?.handleNumpadKeypress(with: keyCodeN.uint16Value)
    })
    //    self.nextResponder = self.numpadView?.nextResponder // TODO: This necessary?
    //    self.numpadView = NRNumpadView.init()
    self.loadApplist()
  }
  
  //  override func viewDidLoad() {
  //
  //  }
  
  func loadApplist() {
    let urls = FileManager.default.urls(for: .applicationDirectory, in: .localDomainMask)
    guard let url = urls.first else { return }
    let properties : [URLResourceKey] = [URLResourceKey.localizedNameKey, URLResourceKey.creationDateKey, URLResourceKey.localizedTypeDescriptionKey]
    let appUrls = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: properties, options:.skipsHiddenFiles)
    if let appUrls = appUrls {
      self.appList = appUrls
    }
  }
  
  
}


