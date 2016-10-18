//
//  StudentListTableViewCell.swift
//  p2p
//
//  Created by Arnav Gudibande on 10/17/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class StudentListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var studentPic: UIImageView!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentLocation: UILabel!
    @IBOutlet weak var studentSubject: UILabel!
    @IBOutlet weak var studentHours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cardView.layer.cornerRadius = 0.0
        self.cardView.layer.shadowOpacity = 0.25
        self.cardView.layer.shadowRadius = 2.0
        self.cardView.layer.shadowColor = UIColor.black.cgColor
        self.cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
