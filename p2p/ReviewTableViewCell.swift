//
//  ReviewTableViewCell.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/18/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit
import SwiftDate

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewText: UILabel!
    
    private var _review: Review? = nil
    var review: Review? {
        set(value) {
            _review = value
            
            self.dateLabel.text = self.review!.date!.string(dateStyle: .long, timeStyle: .none)
            self.reviewText.text = self.review!.text
        }
        get {
            return _review
        }
    }

}
