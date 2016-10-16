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

 
