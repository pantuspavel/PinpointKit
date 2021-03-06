//
//  SystemLogCollectorTests.swift
//  PinpointKit
//
//  Created by Andrew Harrison on 8/5/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import XCTest
@testable import PinpointKit

class SystemLogCollectorTests: XCTestCase {
    
    func testLogCollectorCollectsLogs() {
        let testString = "TestLog"
        let systemLogCollector = SystemLogCollector(loggingType: .Testing)
        
        NSLog(testString)
        NSLog(testString)
        NSLog(testString)
        
        let expectation = defaultExpectation()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let logs = systemLogCollector.retrieveLogs()
            
            guard let firstLog = logs.first else { return XCTFail("There should be at least 1 log.") }
            
            XCTAssertEqual(logs.count, 3)
            XCTAssertTrue(firstLog.containsString(testString))
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testLogCollectorCollecsLogInOrder() {
        let testString1 = "First"
        let testString2 = "Second"
        let testString3 = "Third"
        
        let systemLogCollector = SystemLogCollector(loggingType: .Testing)
        
        NSLog(testString1)
        NSLog(testString2)
        NSLog(testString3)
        
        let expectation = defaultExpectation()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            let logs = systemLogCollector.retrieveLogs()
            
            guard logs.count == 3 else { return XCTFail("Count should be 3.") }
            
            let firstLog = logs[0]
            let secondLog = logs[1]
            let thirdLog = logs[2]
            
            XCTAssertEqual(logs.count, 3)
            XCTAssertTrue(firstLog.containsString(testString1))
            XCTAssertTrue(secondLog.containsString(testString2))
            XCTAssertTrue(thirdLog.containsString(testString3))
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
    }
    
    func testLogCollectorDoesNotCollectPreviousLogs() {
        NSLog("Hey")
        NSLog("I'm a log!")

        let systemLogCollector = SystemLogCollector(loggingType: .Testing)
        
        XCTAssertEqual(systemLogCollector.retrieveLogs().count, 0)
    }
    
    func testLogCollectorHasNoLogsInitially() {
        let systemLogCollector = SystemLogCollector(loggingType: .Testing)
        
        let logs = systemLogCollector.retrieveLogs()
        
        XCTAssertEqual(logs.count, 0)
    }
}
