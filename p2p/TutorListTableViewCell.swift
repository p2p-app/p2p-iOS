//
//  TutorListTableViewCell.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

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
            self.ratingLabel.text = String(format:"%.1f", (self.tutor!.stars)!) + "/5"
            self.locationLabel.text = self.tutor!.location
            self.subjectLabel.text = self.tutor!.subjects?.joined(separator: ", ")
        }
        get {
            return _tutor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
