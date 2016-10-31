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
    @IBOutlet weak var ratingView: CosmosView!
    
    private var _review: Review? = nil
    var review: Review? {
        set(value) {
            _review = value
            
            self.dateLabel.text = self.review!.date!.string(dateStyle: .long, timeStyle: .none)
            self.reviewText.text = self.review!.text
            
            if let stars = self.review!.stars {
                self.ratingView.rating = Double(stars)
                self.ratingView.filledColor = #colorLiteral(red: 0.2207909822, green: 0.7478784919, blue: 0.9191411138, alpha: 1)
                self.ratingView.filledBorderWidth = 0
                self.ratingView.emptyColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
                self.ratingView.emptyBorderWidth = 0
            } else {
                self.ratingView.alpha = 0.5
                self.ratingView.rating = 5
                self.ratingView.filledColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1)
                self.ratingView.filledBorderColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1)
            }
        }
        get {
            return _review
        }
    }

}
