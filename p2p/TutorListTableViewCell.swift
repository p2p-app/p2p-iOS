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
   
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var cardView: CardView!
    
    private var _tutor: Tutor? = nil
    var tutor: Tutor? {
        set(value) {
            _tutor = value
            
            self.nameLabel.text = self.tutor!.name
            self.ratingLabel.text = "\(self.tutor!.stars == nil ? "-":  String(describing: self.tutor!.stars!))/5"
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
