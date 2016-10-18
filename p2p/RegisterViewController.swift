//
//  NewAccountViewController.swift
//  ui_stuff
//
//  Created by Arnav Gudibande on 10/16/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import OHHTTPStubs
import pop

class RegisterViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var nameField: MainTextField!
    @IBOutlet weak var usernameField: MainTextField!
    @IBOutlet weak var passwordField: MainTextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var loginLabel: UIButton!
    @IBOutlet weak var userRole: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
    }

    @IBAction func createUser(_ sender: AnyObject) {
        if usernameField.text! == "" || passwordField.text! == "" || nameField.text! == "" {
            let shake = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            shake?.springBounciness = 20
            shake?.velocity = 1500
            
            self.createButton.layer.pop_add(shake, forKey: "shake")
            
            return
        }
        
        
        OHHTTPStubs.removeAllStubs()

        _ = stub(condition: isHost("p2p.anuv.me")) { _ in
            // Stub it with our "wsresponse.json" stub file (which is in same bundle as self)
            let stubPath = OHPathForFile("create.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type" as NSObject:"application/json" as AnyObject])
        }
        
        User.create(username: usernameField.text!, password: passwordField.text!, name: nameField.text!) { (user, error) in
            if error != nil {
                P2PManager.sharedInstance.user = nil
                
                let shake = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                shake?.springBounciness = 20
                shake?.velocity = 2500
                
                self.createButton.layer.pop_add(shake, forKey: "shake")
                
                return
            }
            
            self.performSegue(withIdentifier: "toNext", sender: self)
        }
        
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "toNext":
            if P2PManager.sharedInstance.user != nil {
                return true
            } else {
                return false
            }
        default:
            return true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordField {
            self.view.endEditing(true)
        } else if textField == nameField {
            usernameField.becomeFirstResponder()
        } else if textField == usernameField {
            passwordField.becomeFirstResponder()
        }
        
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2.2, animations: {
            self.nameField.alpha = 1.0
            self.usernameField.alpha = 1.0
            self.passwordField.alpha = 1.0
            self.createButton.alpha = 1.0
            self.logo.alpha = 1.0
            self.loginLabel.alpha = 1.0
            self.userRole.alpha = 1.0
        })
    }
}
