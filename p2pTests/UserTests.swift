//
//  UserTests.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/17/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import p2p

class UserTests: XCTestCase {
    func testLogin() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp = expectation(description: "Test Login")
        
        P2PManager.sharedInstance.authorize(username: "username", password: "password") { (error: Error?) in
            if error != nil {
                switch error as! P2PErrors {
                case .AuthenticationFailed(_):
                    XCTAssert(false)
                    return
                default:
                    break
                }
            }
            
            print(P2PManager.sharedInstance.token)
            XCTAssert(P2PManager.sharedInstance.user?.username == "username")
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testFailedLogin() {
        let exp = expectation(description: "Test Login")
        
        P2PManager.sharedInstance.authorize(username: "fail", password: "fail") { (error: Error?) in
            switch error as! P2PErrors {
            case .AuthenticationFailed:
                XCTAssert(true)
                break
            default:
                XCTAssert(false)
                break
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testCreate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp = expectation(description: "Test Create")
        let unique = arc4random()
        
        User.create(username: "iosTestUser\(unique)", password: "password", name: "amar") { (user, error) in
            if error == nil {
                print((P2PManager.sharedInstance.user?.username)! + "==" + "iosTestUser\(unique)")
                XCTAssert((P2PManager.sharedInstance.user?.username)! == "iostestuser\(unique)")
                
            } else {
                fatalError()
            }
            
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testFailedCreate() {
        let exp = expectation(description: "Test Create")
        
        User.create(username: "amarjayr", password: "password", name: "amar") { (user, error) in
            switch error as! P2PErrors {
            case .ResourceConflict:
                XCTAssert(true)
                break
            default:
                XCTAssert(false)
                break
            }

            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
