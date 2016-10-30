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
    
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        switchView = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchView!)
        
        sessionsTableview.delegate = self
        sessionsTableview.dataSource = self
        
        updateSessions()
    }
    
    func updateSessions() {
        (P2PManager.sharedInstance.user as! Tutor).getSessions(state: .pending) { (sessions, error) in
            if error != nil {
                
                return
            }
            
            self.sessions = sessions as? [Session]
            
            self.sessionsTableview.reloadSections([0], with: UITableViewRowAnimation.middle)
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 60, target:self, selector: #selector(SessionListViewController.updateSessions), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
}


extension SessionListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath) as! SessionListTableViewCell
        
        cell.session = sessions?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sessions == nil {
            return 0
        }
        
        return (sessions?.count)!
    }
}
