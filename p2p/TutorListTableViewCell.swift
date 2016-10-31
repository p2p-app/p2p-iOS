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
    @IBOutlet weak var distanceLabel: UILabel!
    
    private var _tutor: Tutor? = nil
    var tutor: Tutor? {
        set(value) {
            _tutor = value
            
            self.nameLabel.text = self.tutor!.name
            self.distanceLabel.text = ("\(self.tutor!.distance!) mi")
            
            if let stars = self.tutor?.stars {
                self.ratingView.rating = stars
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
            self.locationLabel.text = self.tutor!.city
            self.subjectLabel.text = self.tutor!.subjects?.joined(separator: ", ").capitalized
            
            if self.tutor!.profileURL != nil {
                self.iconImage.af_setImage(withURL: self.tutor!.profileURL!)
                self.iconImage.layer.cornerRadius = 50
                self.iconImage.layer.masksToBounds = true
            } else {
                self.iconImage.image = #imageLiteral(resourceName: "default")
            }
        }
        get {
            return _tutor
        }
    }
}
