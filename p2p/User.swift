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
    
}
