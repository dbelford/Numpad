//
//  DeviceListTest.swift
//  NumpadTestsUnhosted
//
//  Created by David Belford on 9/25/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import XCTest

class DeviceListener : DeviceListDelegate {
  
  var expectation : XCTestExpectation
  var count = 0 { didSet {
    print("The current count: \(count)")
    if count > 4 {
      self.expectation.fulfill()
    }
    }
  }
  init(expectation : XCTestExpectation) {
    self.expectation = expectation
  }
  
  func devicesChanged() {
    
  }
  
  func deviceRemoval(devices: DeviceList) {
    self.count += 1
    print("Removal \(devices.devices.count)")
  }
  
  func deviceMatches(devices: DeviceList) {
    print("Addition \(devices.devices.count)")
  }
  
  func deviceValueChanged(devices: DeviceList) {
    
  }
}

class DeviceListTest: XCTestCase {
  var deviceListener : DeviceListener?
  var deviceList : DeviceList?
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.deviceList = DeviceList()
    let expectation = XCTestExpectation(description: "Devices changed.")
    self.deviceListener = DeviceListener(expectation: expectation)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.deviceList = nil
    
    super.tearDown()
    
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    guard let deviceListener = self.deviceListener else {
      XCTAssert(false, "Failed init.")
      return
    }
//    self.deviceList?.delegate = self.deviceListener
    print("\(self.deviceList?.devices[0] as AnyObject)")
    self.wait(for: [deviceListener.expectation], timeout: 25)
    print("WAITING")
    print("TEST COMPLETE")
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
