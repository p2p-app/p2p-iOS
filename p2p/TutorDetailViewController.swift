//
//  TutorDetailViewController.swift
//  ui_stuff
//
//  Created by Arnav Gudibande on 10/16/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import SnapKit

class TutorDetailViewController: UIViewController {
    
    var tutor: Tutor?
    
    @IBOutlet var requestView: RequestView!
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
        self.ratingLabel.text = "\(self.tutor!.stars == nil ? "-":  String(describing: self.tutor!.stars!))/5"
        self.locationLabel.text = self.tutor!.city
        self.subjectLabel.text = self.tutor!.subjects?.joined(separator: ", ").capitalized
        self.bioLabel.text = self.tutor!.bio

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
    
    @IBAction func cancelSession(_ sender: AnyObject) {
        //UIApplication.shared.keyWindow?.willRemoveSubview(UIApplication.shared.keyWindow!.viewWithTag(0)!)
        //UIApplication.shared.keyWindow?.willRemoveSubview(UIApplication.shared.keyWindow!.viewWithTag(1)!)
        requestView.removeFromSuperview()
        UIApplication.shared.keyWindow?.subviews[(UIApplication.shared.keyWindow?.subviews.count)!-1].removeFromSuperview()
    }
    
    @IBAction func didRequestTutor(_ sender: AnyObject) {
        UtilityManager.sharedInstance.locationManager.delegate = UtilityManager.sharedInstance
        UtilityManager.sharedInstance.locationManager.startUpdatingLocation()
        
        Session.createSession(with: tutor!.id!, at: (UtilityManager.sharedInstance.location.long, UtilityManager.sharedInstance.location.lat), on: Date()) { (session, error) in
            UtilityManager.sharedInstance.locationManager.stopUpdatingLocation()
            
            if error != nil {
            
                return
            }
            
            let bgOverlay = UIView(frame: self.view.frame)
            bgOverlay.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
            bgOverlay.alpha = 0.0
            bgOverlay.tag = 0
            
            UIApplication.shared.keyWindow?.addSubview(bgOverlay)
            
            
            bgOverlay.snp.makeConstraints({ (make) in
                make.height.equalTo(UIApplication.shared.keyWindow!)
                make.width.equalTo(UIApplication.shared.keyWindow!)
                make.center.equalTo(UIApplication.shared.keyWindow!)
            })
            
            UIView.animate(withDuration: 0.2, animations: { 
                bgOverlay.alpha = 0.7
            })
            
            self.requestView.layer.cornerRadius = 5.0
            self.requestView.clipsToBounds = true
            UIApplication.shared.keyWindow?.addSubview(self.requestView)
            self.requestView.tag = 1
            self.requestView.snp.makeConstraints({ (make) in
                make.center.equalTo(UIApplication.shared.keyWindow!)
                make.width.equalTo(UIApplication.shared.keyWindow!.frame.size.width-40)
                make.height.equalTo(180)
            })

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
