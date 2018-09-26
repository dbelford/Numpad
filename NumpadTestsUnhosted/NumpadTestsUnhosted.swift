//
//  NumpadTestsUnhosted.swift
//  NumpadTestsUnhosted
//
//  Created by David Belford on 9/15/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import XCTest

class NumpadTestsUnhosted: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  
  func testDeviceFetch() {
    let d = DeviceList()
    print("\(d.devices as AnyObject)")
//    print("\(d.deviceList as AnyObject)")
//    dump(d.deviceList)
  }
  
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    print("FIX IT")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
