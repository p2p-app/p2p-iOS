//
//  TutorDetailViewController.swift
//  ui_stuff
//
//  Created by Arnav Gudibande on 10/16/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import OHHTTPStubs

class TutorDetailViewController: UIViewController {
    
    var tutor: Tutor?
    
    @IBOutlet weak var tutorView: UIView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        self.nameLabel.text = self.tutor!.name
        self.ratingLabel.text = String(format:"%.1f", (self.tutor!.stars)!) + "/5"
        self.locationLabel.text = self.tutor!.location
        self.subjectLabel.text = self.tutor!.subjects?.joined(separator: ", ")
        self.bioLabel.text = self.tutor!.bio
        
        OHHTTPStubs.removeAllStubs()
        _ = stub(condition: isHost("p2p.anuv.me")) { _ in
            let stubPath = OHPathForFile("reviews.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
        }
        
        tutor!.getReviews { (error) in
            if error != nil {
                
                return
            }
            
            self.reviewTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didRequestTutor(_ sender: AnyObject) {
        UtilityManager.sharedInstance.locationManager.delegate = UtilityManager.sharedInstance
        UtilityManager.sharedInstance.locationManager.startUpdatingLocation()
        
        Session.createSession(with: tutor!.id!, at: (UtilityManager.sharedInstance.location.long, UtilityManager.sharedInstance.location.lat), on: Date()) { (session, error) in
            UtilityManager.sharedInstance.locationManager.stopUpdatingLocation()
            
            if error != nil {
            
                return
            }
            
            
        }
    }
}

extension TutorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        
        cell.review = tutor!.reviews![indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tutor?.reviews == nil {
            return 0
        }
        
        return (tutor?.reviews?.count)!
    }
}
