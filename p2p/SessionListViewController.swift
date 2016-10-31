//
//  SessionListViewController.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/30/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class SessionListViewController: UIViewController {

    var sessions: [Session]?
    
    @IBOutlet weak var sessionsTableview: UITableView!
    var switchView: UISwitch!
    
    var sessionUpdateTimer = Timer()
    var locationUpdateTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.title = "Sessions"
        
        locationUpdateTimer = Timer.scheduledTimer(timeInterval: 60*3, target:self, selector: #selector(SessionListViewController.updateTutorLocation), userInfo: nil, repeats: true)
        switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        switchView.isOn = true
        switchView.onTintColor = #colorLiteral(red: 0.2207909822, green: 0.7478784919, blue: 0.9191411138, alpha: 1)
        switchView.addTarget(self, action: #selector(switchSwitched(sender:)), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchView!)
        
        sessionsTableview.delegate = self
        sessionsTableview.dataSource = self
        
        updateTutorLocation()
    }
    
    func switchSwitched(sender: UISwitch!) {
        if switchView.isOn {
            locationUpdateTimer = Timer.scheduledTimer(timeInterval: 60*3, target:self, selector: #selector(SessionListViewController.updateTutorLocation), userInfo: nil, repeats: true)
        } else {
            locationUpdateTimer.invalidate()
        }
        
        self.sessionsTableview.reloadData()
    }
    
    func updateTutorLocation() {
        UtilityManager.sharedInstance.locationManager.delegate = UtilityManager.sharedInstance
        P2PManager.sharedInstance.updateLocation(location: (UtilityManager.sharedInstance.location.lat, UtilityManager.sharedInstance.location.long)) { (error) in
            if error != nil {
                
                return
            }
        }
    }
    
    func updateSessions() {
        (P2PManager.sharedInstance.user as! Tutor).getSessions(state: .pending) { (sessions, error) in
            if error != nil {
                
                return
            }
            
            self.sessions = sessions as? [Session]
            
            self.sessionsTableview.reloadSections([0], with: UITableViewRowAnimation.fade)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        updateSessions()
        sessionUpdateTimer = Timer.scheduledTimer(timeInterval: 10, target:self, selector: #selector(SessionListViewController.updateSessions), userInfo: nil, repeats: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "toSessionDetail":
            let destination = segue.destination as! SessionDetailViewController
            destination.session = (sender as! SessionListTableViewCell).session
        default:
            break
        }
    }

}


extension SessionListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionListTableViewCell
        
        cell.session = sessions?[indexPath.row]
        
        if !switchView.isOn {
            cell.isUserInteractionEnabled = false
            cell.cardView.alpha = 0.7
        } else {
            cell.isUserInteractionEnabled = true
            cell.cardView.alpha = 1
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sessions == nil {
            return 0
        }
        
        return (sessions?.count)!
    }
}
