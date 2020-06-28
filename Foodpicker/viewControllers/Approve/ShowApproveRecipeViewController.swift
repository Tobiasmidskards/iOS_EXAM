//
//  ShowApproveRecipeViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 28/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class ShowApproveRecipeViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var StyleLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var goToRecipeButton: UIButton!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var db : Firestore!
    var recipe : Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        setupStyling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        db.collection("styles").document(recipe.style_id).getDocument() {(querySnapshot, err) in if let err = err {
            print("Error getting documents: \(err)")
        } else {
            self.StyleLabel.text = (querySnapshot!["name"] as! String)
            self.nameLabel.text = self.recipe.name
            self.descriptionTextField.text = self.recipe.description
            }
            
        }
    }
    
    func setupStyling() {
        Style.styleFilledButton(approveButton)
        Style.styleFilledThirdButton(goToRecipeButton)
        Style.styleHollowButton(backButton)
        errorLabel.isHidden = true
        descriptionTextField.isEditable = false;
        descriptionTextField.isSelectable = false;
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func approveButtonTapped(_ sender: Any) {
        db.collection("recipes").document(recipe.id).updateData(["approved" : true]) {
            (err) in if err != nil {
                print("Something went wrong..")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func goToRecipeButtonTapped(_ sender: Any) {
        if (recipe != nil) {
            if (verifyUrl(urlString: recipe.link)) {
                guard let url = URL(string: recipe.link) else { return }
                UIApplication.shared.open(url)
            }
            else {
                errorLabel.text = "Not a valid link"
                errorLabel.isHidden = false
            }
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
