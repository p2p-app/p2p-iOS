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
                
                self.locationLabel.text = "\(placemark![0].locality)"
                //self.locationLabel.text = "\(placemark![0].subThoroughfare) \(placemark![0].thoroughfare), \(placemark![0].postalCode) \(placemark![0].locality), \(placemark![0].administrativeArea) \(placemark![0].country)"
            
                let source = MKMapItem( placemark: MKPlacemark(
                    coordinate: CLLocationCoordinate2DMake(UtilityManager.sharedInstance.location.long, UtilityManager.sharedInstance.location.lat),
                    addressDictionary: nil))
                let destination = MKMapItem(placemark: MKPlacemark(
                    coordinate: placemark![0].location!.coordinate,
                    addressDictionary: nil))
                
                let directionsRequest = MKDirectionsRequest()
                directionsRequest.source = source
                directionsRequest.destination = destination
                
                let directions = MKDirections(request: directionsRequest)
                
                directions.calculate { (response, error) -> Void in
                    print(error)
                    let distance = Int((response!.routes.first?.distance)! * 0.000621371)
                    self.distanceLabel.text = "\(distance) mi"
                }
            }
            
            if self.session!.student!.profileURL != nil {
                self.iconImage.af_setImage(withURL: self.session!.student!.profileURL!)
                self.iconImage.layer.cornerRadius = self.iconImage.frame.width/2
                self.iconImage.layer.masksToBounds = true
            }
        }
        get {
            return _session
        }
    }

}
