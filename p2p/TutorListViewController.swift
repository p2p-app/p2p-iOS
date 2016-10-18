//
//  TutorListViewController.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit
import OHHTTPStubs
import pop

class TutorListViewController: UIViewController {
    @IBOutlet weak var tutorTableView: UITableView!
    var tutors: [Tutor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        tutorTableView.delegate = self
        tutorTableView.dataSource = self
        
        OHHTTPStubs.removeAllStubs()
        
        _ = stub(condition: isHost("p2p.anuv.me")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("tutors.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
        }
        
        Tutor.getAll(at: (0, 0), for: "English") { (tutors, error) in
            if error != nil {
                
                return
            }
            
            self.tutors = tutors as? [Tutor]
            
            self.tutorTableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTutorDetail" {
        }
    }


}

extension TutorListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorCell", for: indexPath) as! TutorListTableViewCell
        
        cell.nameLabel.text = tutors?[indexPath.row].name
        cell.ratingLabel.text = String(format:"%.1f", (tutors?[indexPath.row].stars)!) + "/5"
        cell.locationLabel.text = tutors?[indexPath.row].location
        cell.subjectLabel.text = tutors?[indexPath.row].subjects?.joined(separator: ", ")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tutors == nil {
            return 0
        }
        
        return (tutors?.count)!
    }

}
