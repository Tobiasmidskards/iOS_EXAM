//
//  NewRecipeViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 26/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class NewRecipeViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var db : Firestore!
    var style : FoodStyle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupStyling()
    }
    
    func setupStyling() {
        Style.styleTextField(nameTextField)
        Style.styleTextField(linkTextField)
        Style.styleFilledButton(addButton)
        Style.styleHollowButton(backButton)
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        
        // is all fields filled?
        if (nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            linkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            return "Please fill in all fields"
        }
        
        return nil
    }
    
    func showError(_ message : String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let error = validateFields()
        
        if (error != nil) {
            showError(error!)
            return
        }
        
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let link = linkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        db.collection("recipes").addDocument(data: ["name" : name!, "link" : link!, "description" : description!, "approved" : false, "style_id" : style.id, "user_id" : Auth.auth().currentUser!.uid]) {
            (err) in if err != nil {
                print("Something went wrong..")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
