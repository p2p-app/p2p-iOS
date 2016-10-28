//
//  P2PManager.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import Foundation
import Alamofire

let P2PBaseURL = "http://p2p.anuv.me/api"

typealias P2PCompletionBlock = (Error?) -> ()
typealias P2PBooleanCompletionBlock = (Bool, Error?) -> ()
typealias P2PObjectCompletionBlock = (AnyObject?, Error?) -> ()
typealias P2PArrayCompletionBlock = ([AnyObject]?, Error?) -> ()

class P2PManager {
    static let sharedInstance = P2PManager()
    
    public var sessionManager: SessionManager
    
    public var user: User?
    fileprivate var _token: String?
    
    public var token: String? {
        set(value) {
            _token = value

            if token != nil {
                updateUser { (error) in return}
            } else {
                user = nil
            }
        }
        
        get {
            return _token
        }
    }
    
    private init() {
        sessionManager = SessionManager()
    }
    
    public func authorize(username: String, password: String, completion: @escaping P2PCompletionBlock) {
        self.sessionManager.request("\(P2PBaseURL)/auth", method: .post, parameters: ["username": username, "password": password]).responseJSON { response in
            switch (response.response?.statusCode)! {
            case 200:
                break
            case 401:
                completion(P2PErrors.AuthenticationFailed(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            default:
                completion(P2PErrors.UknownError(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            }
            
            switch response.result {
            case .success:
                self._token = (response.result.value as! NSDictionary).object(forKey: "token") as! String?
            case .failure(let error):
                completion(P2PErrors.UknownError(original: error, description: nil))
                return
            }
        }.responseObject(keyPath: "data") { (response: DataResponse<User>) in
            switch response.result {
            case .success:
                self.user = response.result.value
                completion(nil)
            default:
                break
            }
        }
    }
    
    public func updateUser(completion: @escaping P2PCompletionBlock) {
        self.sessionManager.request("\(P2PBaseURL)/auth", method: .get, headers: ["Authorization": "Bearer \(P2PManager.sharedInstance.token)"]).responseJSON { response in
            switch (response.response?.statusCode)! {
            case 200:
                break
            case 401:
                completion(P2PErrors.AuthenticationFailed(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            default:
                completion(P2PErrors.UknownError(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            }
            
            switch response.result {
            case .success:
                break
            case .failure(let error):
                completion(P2PErrors.UknownError(original: error, description: nil))
                return
            }
            }.responseObject { (response: DataResponse<User>) in
                switch response.result {
                case .success:
                    self.user = response.result.value
                    completion(nil)
                default:
                    break
                }
        }
    }
    
    public func logout() {
        self.token = nil
        self.user = nil
    }
}
