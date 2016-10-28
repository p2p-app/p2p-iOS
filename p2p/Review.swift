//
//  Review.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper
import Alamofire

class Review: Mappable {
    fileprivate(set) public var id: String?
    fileprivate(set) public var author: User?
    fileprivate(set) public var text: String?
    fileprivate(set) public var date: Date?
    fileprivate(set) public var stars: Int?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        id                      <-  map["id"]
        author                  <-  map["author"]
        text                    <-  map["reviewText"]
        date                    <-  (map["date"], DateTransform())
        stars                   <-  map["stars"]
    }
    
}
