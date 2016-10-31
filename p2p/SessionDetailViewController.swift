//
//  SessionDetailViewController.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/30/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit
import MapKit

class SessionDetailViewController: UIViewController {
    
    var session: Session?
    
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var commenceButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    let regionRadius: CLLocationDistance = 1000
    
    var sessionUpdateTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = self.session!.student!.name
        
        UtilityManager.sharedInstance.address(for: self.session!.location) { (placemark, error) in
            if error != nil {
                return
            }
            
            let coordinateRegion =  MKCoordinateRegionMakeWithDistance(placemark![0].location!.coordinate, self.regionRadius * 2.0, self.regionRadius * 2.0)
            self.mapView.setRegion(coordinateRegion, animated: true)
            
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = placemark![0].location!.coordinate
            self.mapView.addAnnotation(dropPin)
            
            self.locationLabel.text = "\(placemark![0].locality!)"
            self.addressButton.setTitle("\(placemark![0].subThoroughfare!) \(placemark![0].thoroughfare!), \(placemark![0].postalCode!) \(placemark![0].locality!), \(placemark![0].administrativeArea!) \(placemark![0].country!)", for: .normal)            
            self.distanceLabel.text = "\(Int(placemark![0].location!.distance(from: CLLocation(latitude: UtilityManager.sharedInstance.location.long, longitude: UtilityManager.sharedInstance.location.lat)) * 0.000621371)) mi"
        }
        
        if self.session!.student!.profileURL != nil {
            self.iconImage.af_setImage(withURL: self.session!.student!.profileURL!)
            self.iconImage.layer.cornerRadius = 50
            self.iconImage.layer.masksToBounds = true
        } else {
            self.iconImage.image = #imageLiteral(resourceName: "default")
        }
        
        switch session!.state! {
        case .commenced:
            self.setCommenceView()
        default:
            break
        }
    }
    
    func updateSession() {
        Session.get(session: session!.id!) { (session, error) in
            self.session = session as! Session?
            
            if self.session!.state == .cancelled {
                _ = self.navigationController?.popViewController(animated: true)
                self.sessionUpdateTimer.invalidate()
            }
        }
    }
    
    @IBAction func openMaps(_ sender: AnyObject) {
        UIApplication.shared.open(URL(string: "http://maps.apple.com/?ll=\(self.session!.location.latitude),\(self.session!.location.longitude)")!, options: [:]) { (finished) in
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sessionUpdateTimer = Timer.scheduledTimer(timeInterval: 7, target:self, selector: #selector(SessionDetailViewController.updateSession), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.sessionUpdateTimer.invalidate()
    }
    
    @IBAction func accept(_ sender: AnyObject) {
        session!.confirm(completion: { (error) in
            if error != nil {
                
                return
            }
            
            self.setAcceptView()

        })
    }
    
    func setAcceptView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.acceptButton.alpha = 0
            self.declineButton.alpha = 0
            }, completion: { finished in
                self.acceptButton.isHidden = true
                self.declineButton.isHidden = true
                
                self.commenceButton.alpha = 0
                self.commenceButton.isHidden = false
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.commenceButton.alpha = 1
                })
        })
    }
    
    @IBAction func end(_ sender: AnyObject) {
        session!.complete { (error) in
            if error != nil {
                
                return
            }
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setCommenceView() {
        self.acceptButton.isHidden = true
        self.declineButton.isHidden = true
        
        self.commenceButton.alpha = 1
        self.commenceButton.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: {
            self.commenceButton.alpha = 0
            }, completion: { (finished) in
                self.commenceButton.isHidden = true
                
                self.endButton.alpha = 0
                self.endButton.isHidden = false
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.endButton.alpha = 1
                })
                
        })
    }
    
    @IBAction func commence(_ sender: AnyObject) {
        session!.commence { (error) in
            if error != nil {
                
                return
            }
            
            self.setCommenceView()
        }
    }
    
    @IBAction func decline(_ sender: AnyObject) {
        session!.cancel { (error) in
            if error != nil {
                
                return
            }
            
            _ = self.navigationController?.popViewController(animated: true)
            self.sessionUpdateTimer.invalidate()
        }
    }
}

