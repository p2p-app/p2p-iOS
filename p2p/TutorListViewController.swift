//
//  TutorListViewController.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit
import pop
import CoreLocation

class TutorListViewController: UIViewController {
    
    var tutors: [Tutor]?
    
    @IBOutlet weak var subjectField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var tutorTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tutorTableView.delegate = self
        tutorTableView.dataSource = self
        
        locationField.delegate = self
        subjectField.delegate = self
        
        UtilityManager.sharedInstance.locationManager.delegate = self
        
        Tutor.getAll(at: (UtilityManager.sharedInstance.location.long, UtilityManager.sharedInstance.location.lat), for: "all") { (tutors, error) in
            if error != nil {
                
                return
            }
            
            self.tutors = tutors as? [Tutor]
            
            self.tutorTableView.reloadSections([0], with: UITableViewRowAnimation.middle)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        UtilityManager.sharedInstance.locationManager.delegate = UtilityManager.sharedInstance
        
        super.viewWillDisappear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "toTutorDetail":
            let destination = segue.destination as! TutorDetailViewController
            destination.tutor = (sender as! TutorListTableViewCell).tutor
        default:
            break
        }
    }
}

extension TutorListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorCell", for: indexPath) as! TutorListTableViewCell

        cell.tutor = tutors?[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tutors == nil {
            return 0
        }
        
        return (tutors?.count)!
    }
}

extension TutorListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if subjectField.text == "" {
            subjectField.text = "All Subjects"
            return false
        }
        
        if locationField.text == "me" {
            locationField.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            
            Tutor.getAll(at: (UtilityManager.sharedInstance.location.lat, UtilityManager.sharedInstance.location.long), for: (subjectField.text!.lowercased() == "all subjects" ? "all": subjectField.text!)) { (tutors, error) in
                if error != nil {
                    
                    return
                }
                
                self.tutors = tutors as? [Tutor]
                
                self.tutorTableView.reloadSections([0], with: UITableViewRowAnimation.middle)
            }
        } else {
            locationField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            Tutor.getAll(in: locationField.text!, for: (subjectField.text!.lowercased() == "all subjects" ? "all": subjectField.text!)) { (tutors, error) in
                if error != nil {
                    
                    return
                }
                
                self.tutors = tutors as? [Tutor]
                
                self.tutorTableView.reloadSections([0], with: UITableViewRowAnimation.middle)
            }
        }
        
        self.view.endEditing(true)
        return false
    }
}

extension TutorListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        UtilityManager.sharedInstance.location = (long, lat)
        
        Tutor.getAll(at: (UtilityManager.sharedInstance.location.lat, UtilityManager.sharedInstance.location.long), for: "all") { (tutors, error) in
            if error != nil {
                
                return
            }
            
            self.tutors = tutors as? [Tutor]
            
            self.tutorTableView.reloadData()
        }
        
        UtilityManager.sharedInstance.locationManager.stopUpdatingLocation()
    }
}
