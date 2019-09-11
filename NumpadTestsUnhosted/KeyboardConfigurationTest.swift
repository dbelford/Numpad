//
//  KeyboardConfiguration.swift
//  NumpadTestsUnhosted
//
//  Created by David Belford on 10/17/18.
//  Copyright © 2018 David Belford. All rights reserved.
//

import XCTest

class KeyboardConfigurationTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testPrintConfig() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      let keyboard = KeyboardConfiguration(keyboard: "test")
//      Encoder
      let p = try? PropertyListEncoder().encode(keyboard)
      print(p?.base64EncodedString() ?? "Error")
      if
        let p = p,
        let k = try? PropertyListDecoder().decode(KeyboardConfiguration.self, from: p) {
        print(k)
      }
      
      let keyProfile = try? PropertyListDecoder().decode(KeyboardConfiguration.self,
                                                         from: Data(base64Encoded: "YnBsaXN0MDDRAQJaa2V5Ym9hcmRJRFVIRUxMTwgLFgAAAAAAAAEBAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAc")!)
//      PropertyListSerialization.
      print(keyProfile?.actions.actionone ?? "Decode Error")
      print(keyProfile?.keyboardID ?? "Property error Error")
      print(keyProfile?.anotherKeyboard ?? "Decode Error")
    
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
