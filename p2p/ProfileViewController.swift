//
//  ProfileViewController.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/25/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBAction func logout(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")
        
        UtilityManager.sharedInstance.clear(user: username!)
        
        defaults.removeObject(forKey: "username")
        
        P2PManager.sharedInstance.logout()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "Register")
        self.present(initialViewController, animated: false) { 
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nameLabel.text = P2PManager.sharedInstance.user!.name!
        usernameLabel.text = "@\(P2PManager.sharedInstance.user!.username!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
