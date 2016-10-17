//
//  User.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

public class User: Mappable {
    fileprivate(set) public var id: String?
    fileprivate(set) public var name: String?
    fileprivate(set) public var username: String?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        
        id          <-  map["id"]
        name        <-  map["name"]
        username    <-  map["username"]
    }
}


extension User {
    static func create(username: String, password: String, name: String, completion: @escaping P2PObjectCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(UserRouter.create(username: username, password: password, name: name)).responseObject(keyPath: "data") { (response: DataResponse<User>) in
            P2PManager.sharedInstance.user = response.result.value! as User
            completion(response.result.value!, response.result.error)
            }.responseJSON {  response in switch response.result {
                case .success(let JSON):
                    let response = JSON as! NSDictionary
                
                    P2PManager.sharedInstance.token = response.object(forKey: "token") as? String
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }

    private enum UserRouter: URLRequestConvertible {
        case create(username: String, password: String, name: String)
        
        var method: HTTPMethod {
            switch self {
            case .create:
                return .post
            }
        }
        
        var path: String {
            switch self {
            case .create:
                return "/users"
            }
        }
        
        // MARK: URLRequestConvertible
        
        func asURLRequest() throws -> URLRequest {
            let url = try P2PBaseURL.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            
            return urlRequest
        }
    }
}



