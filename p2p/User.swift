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

public class User: StaticMappable {

    fileprivate(set) public var id: String?
    fileprivate(set) public var name: String?
    fileprivate(set) public var username: String?
    public var profileURL: URL?
    
    public static func objectForMapping(map: Map) -> BaseMappable? {
        
        
        if let type: String = map["type"].value() {
            switch type {
            case "student":
                return User(map: map)
            case "tutor":
                return Tutor(map: map)
            default:
                return nil
            }
        }
        return nil
    }
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        
        id          <-  map["id"]
        name        <-  map["fullname"]
        username    <-  map["username"]
        profileURL  <-  (map["profile"], TransformOf<URL, String>(fromJSON: { if ($0 != nil) { return URL(string: "\(P2PBaseURL)\($0!)") } else { return nil } }, toJSON: { $0!.path }))
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
    
    static func getSessions(for user: String, state: Session.State, completion: @escaping P2PArrayCompletionBlock) {
        if user != P2PManager.sharedInstance.user?.id {
            fatalError("Trying to get sessions for an unauthenticated user")
        }
        
        P2PManager.sharedInstance.sessionManager.request(UserRouter.getSessions(state: state)).responseArray { (response: DataResponse<[Session]>) in
            completion(response.result.value, response.result.error);
        }
    }
    
    func getSessions(state: Session.State, completion: @escaping P2PArrayCompletionBlock) {
        User.getSessions(for: self.id!, state: state, completion: completion)
    }

    private enum UserRouter: URLRequestConvertible {
        case create(username: String, password: String, name: String)
        case getSessions(state: Session.State)
        
        var method: HTTPMethod {
            switch self {
            case .create:
                return .post
            case .getSessions:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .create:
                return "/students/create"
            case .getSessions:
                return "/sessions"
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
            case .getSessions(let state):
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["state": state.rawValue, "tutorData": true, "studentData": true])
                
                urlRequest.setValue("Bearer \(P2PManager.sharedInstance.token!)", forHTTPHeaderField: "Authorization")
            }
            
            return urlRequest
        }
    }
}



