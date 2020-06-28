//
//  ViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 25/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var imHungryButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.logoutButton.isHidden = false
                self.dashboardButton.isHidden = false
                
                self.loginButton.isHidden = true
                self.registerButton.isHidden = true
                print("logged in")
            } else {
                self.logoutButton.isHidden = true
                self.dashboardButton.isHidden = true
                
                self.loginButton.isHidden = false
                self.registerButton.isHidden = false
                print("logged out")
                return
            }
        }
    }
    
    func setupStyles() {
        Style.styleFilledButton(imHungryButton)
        Style.styleHollowButton(registerButton)
        Style.styleFilledSecondaryButton(loginButton)
        
        Style.styleFilledSecondaryButton(dashboardButton)
        Style.styleHollowButton(logoutButton)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    @IBAction func dashboardButtonTapped(_ sender: Any) {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.homeViewController) as? HomeViewController
        
        _ = navigationController?.pushViewController(homeViewController!, animated: true)
    }
    
}
