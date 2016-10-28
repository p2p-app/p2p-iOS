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
import SwiftDate

class Review: Mappable {
    fileprivate(set) public var id: String?
    fileprivate(set) public var author: User?
    fileprivate(set) public var text: String?
    fileprivate(set) public var date: Date?
    fileprivate(set) public var stars: Int?
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        let DateTransformISO8601 = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
            return try! DateInRegion(string: value!, format: .iso8601(options: .withInternetDateTime)).absoluteDate
            }, toJSON: { (value: Date?) -> String? in
                return value?.iso8601
        })
        
        id                      <-  map["id"]
        author                  <-  map["author"]
        text                    <-  map["text"]
        date                    <-  (map["created"], DateTransformISO8601)
        stars                   <-  map["stars"]
    }
    
}
