//
//  ProfileViewController.swift
//  p2p
//
//  Created by Amar Ramachandran on 10/25/16.
//  Copyright © 2016 sfhacks. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    let myPickerController = UIImagePickerController()
    
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
        myPickerController.delegate = self;

        // Do any additional setup after loading the view.
        nameLabel.text = P2PManager.sharedInstance.user!.name!
        usernameLabel.text = "@\(P2PManager.sharedInstance.user!.username!)"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectProfilePicture(_ sender: AnyObject) {
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
        
    {
        profilePicture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)    {
        dismiss(animated: true, completion: nil)
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
