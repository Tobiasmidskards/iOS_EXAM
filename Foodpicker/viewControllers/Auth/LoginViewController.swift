//
//  LoginViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 25/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyling()
    }
    
    func setupStyling() {
        errorLabel.alpha = 0
        Style.styleTextField(emailTextField)
        Style.styleTextField(passwordTextField)
        Style.styleFilledButton(loginButton)
        Style.styleHollowButton(backButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        /*
         let error = validateFields()
         
         if (error != nil) {
         showError(error!)
         return
         }
         
         let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
         let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)*/
        
        let email = "test@test.dk"
        let password = "T0bias1699"
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if err != nil {
                self.showError(err!.localizedDescription)
            } else {
                self.transitionToHome()
            }
            
        }
    }
    
    func validateFields() -> String? {
        
        // is all fields filled?
        if (emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return "Please fill in all fields"
        }
        
        return nil
    }
    
    func showError(_ message : String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as? HomeViewController
        
        _ = navigationController?.pushViewController(homeViewController!, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
