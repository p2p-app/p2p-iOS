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
        name        <-  map["fullname"]
        username    <-  map["username"]
    }
}


extension User {
    static func create(username: String, password: String, name: String, completion: @escaping P2PObjectCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(UserRouter.create(username: username, password: password, name: name)).responseJSON {  response in
            switch (response.response?.statusCode)! {
            case 200:
                break
            case 409: 
                completion(nil, P2PErrors.ResourceConflict(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                break
            default:
                completion(nil, P2PErrors.UknownError(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
            }
            
            switch response.result {
            case .success:
                P2PManager.sharedInstance.token = (response.result.value as! NSDictionary).object(forKey: "token") as! String?
            case .failure(let error):
                completion(nil, P2PErrors.UknownError(original: error, description: nil))
                break
            }
            }.responseObject(keyPath: "data") { (response: DataResponse<User>) in
                switch response.result {
                case .success:
                    P2PManager.sharedInstance.user = response.result.value
                    completion(response.result.value!, nil)
                case .failure(let error):
                    completion(nil, P2PErrors.UknownError(original: error, description: nil))
                    break
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
                return "/students/create"
            }
        }
        
        // MARK: URLRequestConvertible
        
        func asURLRequest() throws -> URLRequest {
            let url = try P2PBaseURL.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            
            switch self {
            case .create(let username, let password, let name):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: ["username": username, "password": password, "fullname": name])
            }
            
            return urlRequest
        }
    }
}



