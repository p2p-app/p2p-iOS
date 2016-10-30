//
//  RegisterViewController.swift


import UIKit
import pop

class RegisterViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var registerScrollView: UIScrollView!
    
    @IBOutlet weak var nameField: MainTextField!
    @IBOutlet weak var usernameField: MainTextField!
    @IBOutlet weak var passwordField: MainTextField!
    @IBOutlet weak var schoolField: MainTextField!
    @IBOutlet weak var bioField: MainTextField!
    @IBOutlet weak var subjectsField: MainTextField!
    @IBOutlet weak var cityField: MainTextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var loginLabel: UIButton!
    @IBOutlet weak var accountTypeSegmentedControl: UISegmentedControl!

    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        schoolField.delegate = self
        bioField.delegate = self
        subjectsField.delegate = self
        cityField.delegate = self
        
        registerScrollView.isScrollEnabled = false
        
        let viewTapGestureRec = UITapGestureRecognizer(target: self, action: #selector(handleViewTap(recognizer:)))
        viewTapGestureRec.cancelsTouchesInView = false
        self.view.addGestureRecognizer(viewTapGestureRec)
    }
    
    func handleViewTap(recognizer: UIGestureRecognizer) {
        nameField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        schoolField.resignFirstResponder()
        bioField.resignFirstResponder()
        subjectsField.resignFirstResponder()
        bioField.resignFirstResponder()
        subjectsField.resignFirstResponder()
        cityField.resignFirstResponder()
    }

    @IBAction func changeAccountType(_ sender: AnyObject) {
        registerScrollView.setContentOffset(CGPoint(x: 0, y: -registerScrollView.contentInset.top), animated: true)

        if accountTypeSegmentedControl.selectedSegmentIndex == 0 {
            registerScrollView.isScrollEnabled = false
            schoolField.isHidden = true
            bioField.isHidden = true
            subjectsField.isHidden = true
            cityField.isHidden = true
            
            passwordField.returnKeyType = .done
        } else {
            registerScrollView.isScrollEnabled = true
            schoolField.isHidden = false
            bioField.isHidden = false
            subjectsField.isHidden = false
            cityField.isHidden = false
            
            passwordField.returnKeyType = .next
        }
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

        if accountTypeSegmentedControl.selectedSegmentIndex == 0 {
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
        } else {
            if schoolField.text! == "" || bioField.text! == "" || cityField.text! == "" || subjectsField.text! == "" {
                let shake = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
                shake?.springBounciness = 20
                shake?.velocity = 1500
                
                self.createButton.layer.pop_add(shake, forKey: "shake")
                
                self.createButton.isEnabled = true
                
                return
            }
            
            Tutor.create(username: usernameField.text!, password: passwordField.text!, name: nameField.text!, school: schoolField.text!, bio: bioField.text!, city: cityField.text!, subjects: subjectsField.text!.components(separatedBy: ","), completion: { (user, error) in
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
            })
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
        if accountTypeSegmentedControl.selectedSegmentIndex == 0 {
            if textField == passwordField {
                self.view.endEditing(true)
            } else if textField == nameField {
                usernameField.becomeFirstResponder()
            } else if textField == usernameField {
                passwordField.becomeFirstResponder()
            }
        } else {
            if textField == cityField {
                self.view.endEditing(true)
            } else if textField == nameField {
                usernameField.becomeFirstResponder()
            } else if textField == usernameField {
                passwordField.becomeFirstResponder()
            } else if textField == passwordField {
                schoolField.becomeFirstResponder()
            } else if textField == schoolField {
                bioField.becomeFirstResponder()
            } else if textField == bioField {
                subjectsField.becomeFirstResponder()
            } else if textField == subjectsField {
                cityField.becomeFirstResponder()
            }
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
