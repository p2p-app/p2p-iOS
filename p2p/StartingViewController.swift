//
//  StartingViewController.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/30/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class StartingViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")
        
        if username != nil {
            P2PManager.sharedInstance.token = UtilityManager.sharedInstance.loadToken(for: username!)
            
            P2PManager.sharedInstance.updateUser(completion: { (error) in
                if error != nil {
                    return
                }
                
                P2PManager.sharedInstance.user!.getAllSessions(completion: { (sessions, error2) in
                    if error2 != nil {
                        return
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "mainTabBar") as! MainTabBarViewController
                    
                    if sessions != nil {
                        initialViewController.sessions = (sessions as! [Session]?)?.filter { $0.state != .completed && $0.state != .cancelled }
                    }
                    
                    self.present(initialViewController, animated: false)
                })
            })
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "registerVC")
            self.present(initialViewController, animated: false)
        }
    }


}
