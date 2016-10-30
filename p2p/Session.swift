//
//  Session.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import Alamofire

class Session: Mappable {
    
    enum State: String {
        case pending
        case confirmed
        case commenced
        case completed
    }
    
    fileprivate(set) public var id: String?
    fileprivate(set) public var location: (latitude: Double, longitude: Double) = (0, 0)
    fileprivate(set) public var tutor: Tutor?
    fileprivate(set) public var student: User?
    fileprivate(set) public var created: Date?
    fileprivate(set) public var state: State?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id                      <-  map["id"]
        location.latitude       <-  map["location.0"]
        location.longitude      <-  map["location.1"]
        tutor                   <-  map["tutor"]
        student                 <-  map["student"]
        created                 <-  (map["created"], DateTransform())
        state                   <-  map["state"]
    }
}

extension Session {
    static func createSession(with tutor: String, at location: (Double, Double), on time: Date, completion: @escaping P2PObjectCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(SessionRouter.create(tutorID: tutor, time: time, location: location)).responseObject { (response: DataResponse<Session>) in
            completion(response.result.value as Session?, response.result.error)
        }
    }
    
    static func get(session id: String, completion: @escaping P2PObjectCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(SessionRouter.get(id: id)).responseObject { (response: DataResponse<Session>) in
            completion(response.result.value as Session?, response.result.error)
        }
    }
    
    static func confirm(session id: String, completion: @escaping P2PCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(SessionRouter.set(state: .confirmed, id: id)).responseJSON { response in
            switch (response.response?.statusCode)! {
            case 200:
                completion(nil)
                break
            case 500:
                completion(P2PErrors.AuthenticationFailed(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            default:
                completion(P2PErrors.UknownError(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            }
        }
    }
    
    func confirm(completion: @escaping P2PCompletionBlock) {
        Session.confirm(session: self.id!) { error in
            if error != nil {
                completion(error)
                return
            }
            
            self.state = .confirmed
            completion(nil)
        }
    }
    
    static func commence(session id: String, completion: @escaping P2PCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(SessionRouter.set(state: .commenced, id: id)).responseJSON { response in
            switch (response.response?.statusCode)! {
            case 200:
                completion(nil)
                break
            case 500:
                completion(P2PErrors.AuthenticationFailed(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            default:
                completion(P2PErrors.UknownError(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            }
        }
    }
    
    func commence(completion: @escaping P2PCompletionBlock) {
        Session.commence(session: self.id!) { error in
            if error != nil {
                completion(error)
                return
            }
            
            self.state = .commenced
            completion(nil)
        }
    }
    
    static func complete(session id: String, completion: @escaping P2PCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(SessionRouter.set(state: .completed, id: id)).responseJSON { response in
            switch (response.response?.statusCode)! {
            case 200:
                completion(nil)
                break
            case 500:
                completion(P2PErrors.AuthenticationFailed(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            default:
                completion(P2PErrors.UknownError(original: response.result.error, description: (response.result.value as! NSDictionary).object(forKey: "message") as! String?))
                return
            }
        }
    }
    
    func complete(completion: @escaping P2PCompletionBlock) {
        Session.complete(session: self.id!) { error in
            if error != nil {
                completion(error)
                return
            }
            
            self.state = .completed
            completion(nil)
        }
    }
    
    static func cancel(completion: @escaping P2PCompletionBlock) {
        
    }
    
    func cancel(completion: @escaping P2PCompletionBlock) {
        Session.cancel { (error) in
            completion(error)
        }
    }
    
    private enum SessionRouter: URLRequestConvertible {
        case create(tutorID: String, time: Date, location: (Double, Double))
        case get(id: String)
        case set(state: Session.State, id: String)
        
        var method: HTTPMethod {
            switch self {
            case .create:
                return .post
            case .get:
                return .get
            case .set:
                return .post
            }
        }
        
        var path: String {
            switch self {
            case .create:
                return "/sessions/create"
            case .get(let id):
                return "/sesions/\(id)"
            case .set(_, let id):
                return "/sesions/\(id)/state"
            }
        }
        
        // MARK: URLRequestConvertible
        
        func asURLRequest() throws -> URLRequest {
            let url = try P2PBaseURL.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            
            switch self {
            case .create(let tutorID, let time, let location):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: ["tutor": tutorID, "long": location.0, "lat": location.1, "time": time.iso8601])
            case .get:
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["tutorData": true, "studentData": true])
            case .set(let state, _):
                urlRequest = try URLEncoding.default.encode(urlRequest, with: ["action": state.rawValue])
            }
            
            urlRequest.setValue("Bearer \(P2PManager.sharedInstance.token!)", forHTTPHeaderField: "Authorization")
            
            return urlRequest
        }
    }
}
