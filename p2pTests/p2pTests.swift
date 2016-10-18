//
//  p2pTests.swift
//  p2pTests
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import p2p

class p2pTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testLogin() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp = expectation(description: "Test Login")
        
        P2PManager.sharedInstance.authorize(username: "username", password: "password") { (error: Error?) in
            if error == nil {
                print(P2PManager.sharedInstance.token)
                XCTAssert(P2PManager.sharedInstance.user?.username == "username")
                
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
    
    func testCreate() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp = expectation(description: "Test Create")
        
        User.create(username: "amarjayr", password: "password", name: "amar") { (user, error) in
            if error == nil {
                XCTAssert(P2PManager.sharedInstance.user?.username == "amarjayr")
                
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
    
    func testGetTutor() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp = expectation(description: "Test get sessions")
        
        _ = stub(condition: isHost("p2p.anuv.me")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("tutor.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
        }
        
        Tutor.get(tutor: "tutorID") { (tutor, error) in
            if error == nil {
                XCTAssert((tutor as! Tutor).name == "amarTutor" && (tutor as! Tutor).reviews?[0].id == "idReviewValue")
                
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
    
    func testCreateSession() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let exp = expectation(description: "Test get sessions")
        
        _ = stub(condition: isHost("p2p.anuv.me")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("session.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
        }
        
        Session.createSession(with: "tutorID", at: (1.0, 2.0), on: Date()) { (session, error) in
            if error == nil {
                XCTAssert((session as! Session).tutor?.id == "tutorID")
                
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
}
