//
//  MainNavigationController.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/16/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    var sessions: [Session]? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sessions = (self.tabBarController as! MainTabBarViewController).sessions
        
        if (P2PManager.sharedInstance.user as? Tutor) != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "requestListVC")
            
            if sessions!.count > 0 {
                let secondary = storyboard.instantiateViewController(withIdentifier: "sessionDetailVC") as! SessionDetailViewController
                secondary.session = sessions![0]
                
                self.setViewControllers([initialViewController, secondary], animated: false)
            } else {
                self.setViewControllers([initialViewController], animated: false)
            }
            
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "tutorListVC")
            
            if sessions!.count > 0 {
                let secondary = storyboard.instantiateViewController(withIdentifier: "tutorDetailViewController") as! TutorDetailViewController
                secondary.tutor = sessions![0].tutor
                secondary.session = sessions![0]
                
                self.setViewControllers([initialViewController, secondary], animated: false)
            } else {
                self.setViewControllers([initialViewController], animated: false)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
