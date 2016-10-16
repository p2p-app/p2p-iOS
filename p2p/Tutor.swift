//
//  Tutor.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

enum subjects {
    case English
    case Math(String)
    case Science(String)
    case Language(String)
    
    var description: String {
        switch self {
        case .English:
            return "English"
        case .Math(let subject):
            return subject
        case .Science(let subject):
            return subject
        case .Language(let subject):
            return subject
        }
    }
}

class Tutor: User {
    fileprivate(set) public var reviews: String?
    fileprivate(set) public var subjects: String?
    fileprivate(set) public var stars: Double?
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        reviews     <- map["reviews"]
        subjects    <- map["subjects"]
        stars       <- map["stars"]
    }
}

extension Tutor {
    static func get(tutor id: String, completion: @escaping P2PObjectCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(TutorRouter.get(id: id)).responseObject { (response: DataResponse<Tutor>) in
            completion(response.result.value!, response.result.error);
        }
    }
    
    static func getAll(at location: (Double, Double), for subject: String, completion: @escaping P2PObjectCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(TutorRouter.getAllWith(location: location, subject: subject)).responseObject { (response: DataResponse<Tutor>) in
            completion(response.result.value!, response.result.error);
        }
    }
    
    static func getReviews(for tutor: String, completion: @escaping P2PArrayCompletionBlock) {
        P2PManager.sharedInstance.sessionManager.request(TutorRouter.getReviews(id: tutor)).responseArray { (response: DataResponse<[Review]>) in
            completion(response.result.value!, response.result.error);
        }
    }
    
    func getReviews(completion: @escaping P2PArrayCompletionBlock) {
        Tutor.getReviews(for: self.id!, completion: completion)
    }
    
    private enum TutorRouter: URLRequestConvertible {
        case get(id: String)
        case getAllWith(location: (Double, Double), subject: String)
        case getReviews(id: String)
        
        var method: HTTPMethod {
            switch self {
            case .get:
                return .get
            case .getAllWith:
                return .get
            case .getReviews:
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .get(let id):
                return "/tutors/\(id)"
            case .getAllWith:
                return "/tutors"
            case .getReviews(let id):
                return "/tutors/\(id)/reviews"
            }
        }
        
        // MARK: URLRequestConvertible
        
        func asURLRequest() throws -> URLRequest {
            let url = try P2PBaseURL.asURL()
            
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            
            switch self {
            case .getAllWith(let location, let subject):
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: ["long": location.0, "lat": location.1, "subject": subject])
            default:
                break
            }
            
            return urlRequest
        }
    }
}

 
