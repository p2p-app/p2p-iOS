//
//  AuthViewController.swift
//  ui_stuff
//
//  Created by Arnav Gudibande on 10/16/16.
//  Copyright © 2016 Arnav Gudibande. All rights reserved.
//

import UIKit
import OHHTTPStubs
import pop

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameField: MainTextField!
    @IBOutlet weak var passwordField: MainTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usernameField.delegate = self
        self.passwordField.delegate = self
    }
    
    @IBAction func login(_ sender: AnyObject) {
        if usernameField.text! == "" || passwordField.text! == "" {
            let shake = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            shake?.springBounciness = 20
            shake?.velocity = 1500
            
            self.loginButton.layer.pop_add(shake, forKey: "shake")
            
            return
        }
        
        P2PManager.sharedInstance.authorize(username: usernameField.text!, password: passwordField.text!) { (error) in
            if error != nil {
                switch error as! P2PErrors {
                case .AuthenticationFailed(_):
                    print(P2PManager.sharedInstance.user?.username)
                    
                    let shake = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                    shake?.springBounciness = 20
                    shake?.velocity = 2500
                    
                    self.loginButton.layer.pop_add(shake, forKey: "shake")
                    break
                default:
                    break
                }
                
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        logoTopConstraint.constant = 0 - 49 - 20
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        logoTopConstraint.constant = 80
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordField {
            self.view.endEditing(true)
        } else if textField == usernameField {
            passwordField.becomeFirstResponder()
        }
        
        return false
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
