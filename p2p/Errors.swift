//
//  Errors.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/17/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import Foundation

enum P2PErrors: Error {
    case AuthenticationFailed(original: Error?, description: String?)
    case ResourceConflict(original: Error?, description: String?)
    case UknownError(original: Error?, description: String?)
}
