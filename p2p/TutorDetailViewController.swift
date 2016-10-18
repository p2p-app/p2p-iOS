//
//  TutorDetailViewController.swift
//  ui_stuff
//
//  Created by Arnav Gudibande on 10/16/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit

class TutorDetailViewController: UIViewController {
    
    var tutor: Tutor?
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        self.nameLabel.text = self.tutor!.name
        self.ratingLabel.text = String(format:"%.1f", (self.tutor!.stars)!) + "/5"
        self.locationLabel.text = self.tutor!.location
        self.subjectLabel.text = self.tutor!.subjects?.joined(separator: ", ")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func didRequestTutor(_ sender: AnyObject) {
    }
}

extension TutorDetailViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        
        cell.review = tutor!.reviews![indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tutor?.reviews?.count)!
    }
}
