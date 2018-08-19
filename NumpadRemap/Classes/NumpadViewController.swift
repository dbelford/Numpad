//
//  NumpadViewController.swift
//  Numpad
//
//  Created by David Belford on 8/14/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import Foundation

class NumpadViewController : NSViewController {
  @IBOutlet var numpadModel : NRNumpadModel?
  @IBOutlet var numpadViewModel : NRNumpadViewModel?
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
    return self.numpadModel?.launchApplication(forKeycode: UInt(keyCode)) ?? false
  }
  
  
  // MARK: - Configure Controller
  
  override func awakeFromNib() {
    super.awakeFromNib()
    //    self.configurePreferencePane()
    //    self.configureConstraints()
    //    self.prefView.removeFromSuperview()
    //    self.numpadModel = NRNumpadModel.init()
    //self.numpadView = NRNumpadView.init() // TODO: This goes here? init maybe?
    self.numpadView = ExpandedNumpadView.init(frame: NSMakeRect(0, 0, 400, 400))
    //    self.numpadView.viewModel = NRNumpadViewModel.init(model: self.numpadModel)
    self.numpadView?.viewModel = self.numpadViewModel;
    self.numpadView?.viewModel?.keycodeActivatedSignal.subscribeNext { [weak self] keyCode in
      guard let strongSelf = self else { return }
      guard let keyCodeN = keyCode as? NSNumber else { return }
      _ = strongSelf.handleNumpadKeypress(with: keyCodeN.uint16Value)
    }
    MASShortcutBinder.shared().bindShortcut(withDefaultsKey: kAppActivationShortcutKey) { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.numpadModel?.launch(NSRunningApplication.current())
    }
  }
  
  override func loadView() {
    super.loadView()
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


