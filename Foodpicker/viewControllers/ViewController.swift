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
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.styleLoginState(logged_id: user != nil)
        }
    }
    
    func styleLoginState(logged_id : Bool) {
        self.logoutButton.isHidden = !logged_id
        self.dashboardButton.isHidden = !logged_id
        
        self.loginButton.isHidden = logged_id
        self.registerButton.isHidden = logged_id
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
