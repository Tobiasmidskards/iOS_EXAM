//
//  HomeViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 25/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var stylesButton: UIButton!
    @IBOutlet weak var approveRecipesButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var db : Firestore!
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        setupStyling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showSpinner(onView: self.view)
        db.collection("users").whereField("uid", isEqualTo:  Auth.auth().currentUser!.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print(querySnapshot!.documents.count)
                for document in querySnapshot!.documents {
                    let role_id = document.data()["role_id"] as! String
                    self.db.collection("roles").document(role_id).getDocument() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            
                            if (querySnapshot!["name"] as! String == "ADMIN") {
                                self.approveRecipesButton.isHidden = false
                            } else {
                                self.approveRecipesButton.isHidden = true
                            }
                            
                        }
                    }
                }
            }
            self.removeSpinner()
        }
    }
    
    func setupStyling() {
        Style.styleFilledButton(stylesButton)
        Style.styleFilledSecondaryButton(approveRecipesButton)
        Style.styleHollowButton(backButton)
        approveRecipesButton.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        let ai = UIActivityIndicatorView.init(style: .large)
        
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpinner?.removeFromSuperview()
            self.vSpinner = nil
        }
    }
}
