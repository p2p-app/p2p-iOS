//
//  SessionListTableViewCell.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/30/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit
import MapKit

class SessionListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var cardView: CardView!
    
    private var _session: Session? = nil
    var session: Session? {
        set(value) {
            _session = value
            
            self.nameLabel.text = self.session!.student!.name

            UtilityManager.sharedInstance.address(for: self.session!.location) { (placemark, error) in
                if error != nil {
                    return
                }
                
                self.locationLabel.text = "\(placemark![0].locality!)"
                
                self.distanceLabel.text = "\(Int(placemark![0].location!.distance(from: CLLocation(latitude: UtilityManager.sharedInstance.location.long, longitude: UtilityManager.sharedInstance.location.lat)) * 0.000621371)) mi"
            }
            
            if self.session!.student!.profileURL != nil {
                self.iconImage.af_setImage(withURL: self.session!.student!.profileURL!)
                self.iconImage.layer.cornerRadius = 50
                self.iconImage.layer.masksToBounds = true
            } else {
                self.iconImage.image = #imageLiteral(resourceName: "default")
            }
        }
        get {
            return _session
        }
    }

}
