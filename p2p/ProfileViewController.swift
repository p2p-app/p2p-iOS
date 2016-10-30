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
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileSetButton: UIButton!
    
    let profileImagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = P2PManager.sharedInstance.user!.name!
        usernameLabel.text = "@\(P2PManager.sharedInstance.user!.username!)"
        
        profileImagePicker.delegate = self
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            P2PManager.sharedInstance.user!.set(picture: image, completion: { (error) in
                if error != nil {
                    
                } else {
                    self.profilePicture.af_setImage(withURL: P2PManager.sharedInstance.user!.profileURL!)
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
                    self.profilePicture.layer.masksToBounds = true
                }
            })
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController {
    
    @IBAction func setProfile(_ sender: AnyObject) {
        profileImagePicker.allowsEditing = false
        profileImagePicker.sourceType = .photoLibrary
        
        present(profileImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: "username")
        
        UtilityManager.sharedInstance.clear(user: username!)
        
        defaults.removeObject(forKey: "username")
        
        P2PManager.sharedInstance.logout()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "registerVC")
        self.present(initialViewController, animated: false) {
            
        }
    }
    
}
