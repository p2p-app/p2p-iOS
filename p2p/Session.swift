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
    fileprivate(set) public var id: String?
    fileprivate(set) public var location: (longitude: Double, latitude: Double) = (0, 0)
    fileprivate(set) public var tutor: Tutor?
    fileprivate(set) public var created: Date?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id                      <-  map["id"]
        location.longitude      <-  map["location.0"]
        location.latitude       <-  map["location.1"]
        tutor                   <-  map["tutor"]
        created                 <-  (map["created"], DateTransform())
    }
}

extension Session {
    static func createSession(with tutor: String, at location: (Double, Double), on time: Date, completion: @escaping P2PObjectCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(SessionRouter.create(tutorID: tutor, time: time, location: location)).responseObject { (response: DataResponse<Session>) in
            completion(response.result.value! as Session, response.result.error)
        }
    }
    
    static func get(game id: String, completion: @escaping P2PObjectCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(SessionRouter.get(id: id)).responseObject { (response: DataResponse<Session>) in
            completion(response.result.value! as Session, response.result.error)
        }
    }
    
    private enum SessionRouter: URLRequestConvertible {
        case create(tutorID: String, time: Date, location: (Double, Double))
        case get(id: String)
        
        var method: HTTPMethod {
            switch self {
            case .create:
                return .post
            case .get:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .create:
                return "/sessions"
            case .get(let id):
                return "/sesions/\(id)"
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
            default:
                break
            }
            
            return urlRequest
        }
    }
}
