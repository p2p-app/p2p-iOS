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
    
    @IBOutlet weak var requestViewNavigationBar: UINavigationBar!
    @IBOutlet weak var reviewRatingView: CosmosView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var reviewCardView: CardView!
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
            self.iconImage.layer.cornerRadius = 50
            self.iconImage.layer.masksToBounds = true
        }
        
        if self.session != nil {
            self.addOverlay()
            self.updateSessionViews()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        if self.session != nil && self.session!.state != .completed && self.session!.state != .cancelled {
            self.sessionUpdateTimer = Timer.scheduledTimer(timeInterval: 7, target:self, selector: #selector(TutorDetailViewController.updateSession), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.sessionUpdateTimer.invalidate()
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
    
    func addOverlay() {
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
    
    @IBAction func didRequestTutor(_ sender: AnyObject) {
        UtilityManager.sharedInstance.locationManager.delegate = UtilityManager.sharedInstance
        UtilityManager.sharedInstance.locationManager.startUpdatingLocation()
        
        Session.createSession(with: tutor!.id!, at: (UtilityManager.sharedInstance.location.long, UtilityManager.sharedInstance.location.lat), on: Date()) { (session, error) in
            self.session = session as! Session?
            
            UtilityManager.sharedInstance.locationManager.stopUpdatingLocation()
            
            if error != nil {
                
                return
            }
            
            self.addOverlay()
            
            self.sessionUpdateTimer = Timer.scheduledTimer(timeInterval: 7, target:self, selector: #selector(TutorDetailViewController.updateSession), userInfo: nil, repeats: true)
        }
    }
    
    func updateSessionViews() {
        if self.session!.state == .confirmed {
            self.loadingView!.removeFromSuperview()
            self.loadingView!.stopAnimating()
            
            self.requestViewCardView.isHidden = false
            self.requestCardViewProfileImage.image = self.iconImage.image
            self.requestCardViewProfileImage.layer.cornerRadius = 25
            self.requestCardViewProfileImage.layer.masksToBounds = true
            self.requestCardViewLabel.text = "\(self.session!.tutor!.name!) is on their way."
            
        } else if self.session!.state == .commenced {
            self.loadingView!.removeFromSuperview()
            self.loadingView!.stopAnimating()
            
            self.requestViewCardView.isHidden = false
            self.requestCardViewProfileImage.image = self.iconImage.image
            self.requestCardViewProfileImage.layer.cornerRadius = 25
            self.requestCardViewProfileImage.layer.masksToBounds = true
            self.requestCardViewLabel.text = "\(self.session!.tutor!.name!) is here."
        } else if self.session!.state == .cancelled {
            self.loadingView!.removeFromSuperview()
            self.loadingView!.stopAnimating()
            
            
            self.cancelSession(self)
        } else if self.session!.state == .completed {
            self.loadingView!.removeFromSuperview()
            self.loadingView!.stopAnimating()
            
            
            self.requestView.addSubview(self.reviewCardView)
            self.reviewCardView.snp.makeConstraints({ (make) in
                make.center.equalTo(self.requestViewCardView)
                make.width.equalTo(self.requestViewCardView)
                make.height.equalTo(self.requestViewCardView)
            })
            
            self.requestView.snp.removeConstraints()
            self.requestView.snp.makeConstraints({ (make) in
                make.topMargin.equalTo(20)
                make.centerX.equalTo(self.view)
                make.width.equalTo(UIApplication.shared.keyWindow!.frame.size.width-40)
                make.height.equalTo(250)
            })
            
            self.requestViewCardView.isHidden = true
            
            let barItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(TutorDetailViewController.postReview))
            barItem.setTitlePositionAdjustment(UIOffset.init(horizontal: -15, vertical: 0), for: .default)
            let navigationItem = UINavigationItem(title: "Review")
            navigationItem.rightBarButtonItem = barItem
            navigationItem.hidesBackButton = true
            self.requestViewNavigationBar.pushItem(navigationItem, animated: false)
            
        }
    }

    func updateSession() {
        Session.get(session: session!.id!) { (session, error) in
            if error != nil {
                return
            }
            
            self.session = session as! Session?
            
            self.updateSessionViews()
        }
    }
    
    func postReview() {
        tutor?.postReview(rating: reviewRatingView.rating, text: reviewTextView.text, completion: { (review, error) in
            if error != nil {
                
                return
            }
        
            self.requestView.snp.removeConstraints()
            self.requestView.removeFromSuperview()
            UIApplication.shared.keyWindow?.subviews[(UIApplication.shared.keyWindow?.subviews.count)!-1].removeFromSuperview()
            
            self.sessionUpdateTimer.invalidate()
        })
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
