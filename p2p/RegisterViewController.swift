//
//  RegisterViewController.swift


import UIKit
import OHHTTPStubs
import pop

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var nameField: MainTextField!
    @IBOutlet weak var usernameField: MainTextField!
    @IBOutlet weak var passwordField: MainTextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var loginLabel: UIButton!
    @IBOutlet weak var userRoleSegmentedControl: UISegmentedControl!

    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    
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
        
        self.createButton.isEnabled = false
        OHHTTPStubs.removeAllStubs()
        User.create(username: usernameField.text!, password: passwordField.text!, name: nameField.text!) { (user, error) in
            self.createButton.isEnabled = true
            if error != nil {
                switch error as! P2PErrors {
                case .ResourceConflict:
                    let shake = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                    shake?.springBounciness = 20
                    shake?.velocity = 2500
                    
                    self.usernameField.layer.pop_add(shake, forKey: "shake")
                    break
                default:
                    break
                }
                return
            }
            
            let defaults = UserDefaults.standard
            defaults.set(P2PManager.sharedInstance.user!.username!, forKey: "username")
            UtilityManager.sharedInstance.save(token: P2PManager.sharedInstance.token!, for: P2PManager.sharedInstance.user!.username!)
            
            self.performSegue(withIdentifier: "toNext", sender: self)
        }
        
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "toNext":
            if P2PManager.sharedInstance.token != nil {
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
            self.view.subviews.forEach({ $0.alpha = 1.0 })
        })
    }
}
