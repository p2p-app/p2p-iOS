//
//  P2PManager.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import Foundation
import Alamofire

let P2PBaseURL = "10.0.1.26/sites/p2p/api"
typealias P2PCompletionBlock = (Error?) -> ()
typealias P2PBooleanCompletionBlock = (Bool, Error?) -> ()
typealias P2PObjectCompletionBlock = (AnyObject?, Error?) -> ()
typealias P2PArrayCompletionBlock = ([AnyObject]?, Error?) -> ()

class P2PManager {
    static let sharedInstance = P2PManager()
    public let sessionManager: SessionManager
    private init() {
        sessionManager = SessionManager()
    }
}
