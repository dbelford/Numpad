//
//  NumpadTests.swift
//  NumpadTests
//
//  Created by David Belford on 8/1/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import XCTest
@testable import Numpad

class NumpadTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //        let apps = NSWorkspace.shared().runningApplications
    let apps = NSWorkspace.shared.runningApplications
    
    dump(apps);
  }
  
  func testShortcut() {
//    init(keyCode : UInt, modifier: NSEventModifierFlags)
    
//    let shortcut = NRShortcut.init(keyCode: 64, modifier: NSEvent.ModifierFlags.command)
//    let jsonEncoder = JSONEncoder()
//    jsonEncoder.outputFormatting = .prettyPrinted
////    NSEncoder.init
//    let data =  NSMutableData()
//    let archiver = NSKeyedArchiver(forWritingWith: data)
//    archiver.encodeConditionalObject(shortcut, forKey: "Shortcut")
//    archiver.finishEncoding()
////    String.ini

    
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
