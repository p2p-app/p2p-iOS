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
    public private(set) var user: User?
    
    fileprivate var _token: String?
    private var token: String? {
        set(value) {
            _token = value
            sessionManager.session.configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(_token)"]
        }
        
        get {
            return _token
        }
    }
    
    private init() {
        sessionManager = SessionManager()
    }
    
    public func authorize(username: String, password: String, completion: P2PCompletionBlock) {
        self.sessionManager.request("\(P2PBaseURL)/login", parameters: ["username": username, "password": password]).validate().responseJSON { response in
            switch response.result {
            case .success:
                self.token = response.result.value as! String?
            case .failure(let error):
                print(error)
            }
        }
    }
}
