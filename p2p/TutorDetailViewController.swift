//
//  TutorDetailViewController.swift
//  ui_stuff
//
//  Created by Arnav Gudibande on 10/16/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class TutorDetailViewController: UIViewController {
    
    var tutor: Tutor?
    var session: Session?
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var requestCardViewLabel: UILabel!
    @IBOutlet weak var requestCardViewProfileImage: UIImageView!
    @IBOutlet weak var requestViewCardView: CardView!
    @IBOutlet var requestView: RequestView!
    @IBOutlet weak var tutorView: UIView!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    
    var sessionUpdateTimer = Timer()
    
    var loadingView: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
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
        self.bioLabel.text = self.tutor!.bio

        tutor!.getReviews { (error) in
            if error != nil {
                
                return
            }
            
            self.reviewTableView.reloadData()
        }
        
        loadingView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: NVActivityIndicatorType.ballTrianglePath, color: #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1), padding: 0)
        self.requestView.addSubview(loadingView!)
        loadingView!.startAnimating()
        loadingView!.snp.makeConstraints({ (make) in
            make.center.equalTo(self.requestView)
            make.height.equalTo(50)
            make.width.equalTo(50)
        })
        self.requestViewCardView.isHidden = true
        
        if self.tutor!.profileURL != nil {
            self.iconImage.af_setImage(withURL: self.tutor!.profileURL!)
            self.iconImage.layer.cornerRadius = self.iconImage.frame.width/2
            self.iconImage.layer.masksToBounds = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension TutorDetailViewController {
    
    @IBAction func cancelSession(_ sender: AnyObject) {
        requestView.removeFromSuperview()
        UIApplication.shared.keyWindow?.subviews[(UIApplication.shared.keyWindow?.subviews.count)!-1].removeFromSuperview()
        
        self.session?.cancel(completion: { (error) in
            if error != nil {
                return
            }
            
            self.sessionUpdateTimer.invalidate()
        })
    }
    
    @IBAction func didRequestTutor(_ sender: AnyObject) {
        UtilityManager.sharedInstance.locationManager.delegate = UtilityManager.sharedInstance
        UtilityManager.sharedInstance.locationManager.startUpdatingLocation()
        
        Session.createSession(with: tutor!.id!, at: (UtilityManager.sharedInstance.location.long, UtilityManager.sharedInstance.location.lat), on: Date()) { (session, error) in
            self.session = session as! Session?
            
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
            
            self.sessionUpdateTimer = Timer.scheduledTimer(timeInterval: 10, target:self, selector: #selector(TutorDetailViewController.updateSession), userInfo: nil, repeats: true)
        }
    }

    func updateSession() {
        Session.get(session: session!.id!) { (session, error) in
            if error != nil {
                return
            }
            
            if self.session!.state == .pending && (session as! Session).state == .confirmed {
                // Going from pending to confirmed
                self.loadingView!.removeFromSuperview()
                self.loadingView!.stopAnimating()
                
                self.requestViewCardView.isHidden = false
                self.requestCardViewProfileImage.image = self.iconImage.image
                self.requestCardViewLabel.text = "\(self.session!.tutor!.name!) is on their way."
                
            }
            
            self.session = session as! Session?
            
            if self.session!.state == .cancelled {
                self.cancelSession(self)
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
