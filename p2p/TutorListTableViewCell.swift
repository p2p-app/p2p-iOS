//
//  TutorListTableViewCell.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit
import AlamofireImage

class TutorListTableViewCell: UITableViewCell {
   
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var cardView: CardView!
    
    private var _tutor: Tutor? = nil
    var tutor: Tutor? {
        set(value) {
            _tutor = value
            
            self.nameLabel.text = self.tutor!.name
            if let stars = self.tutor?.stars {
                self.ratingView.rating = stars
            } else {
                self.ratingView.alpha = 0.5
                self.ratingView.rating = 5
                self.ratingView.filledColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1)
                self.ratingView.filledBorderColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.8039215686, alpha: 1)
            }
            self.locationLabel.text = self.tutor!.city
            self.subjectLabel.text = self.tutor!.subjects?.joined(separator: ", ").capitalized
            
            if self.tutor!.profileURL != nil {
                self.iconImage.af_setImage(withURL: self.tutor!.profileURL!)
                self.iconImage.layer.cornerRadius = self.iconImage.frame.width/2
                self.iconImage.layer.masksToBounds = true
            }
        }
        get {
            return _tutor
        }
    }

}
