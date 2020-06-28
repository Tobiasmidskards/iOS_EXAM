//
//  ShowRecipeViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 26/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class ShowRecipeViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var recipe : Recipe!
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        setupStyling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        nameTextField.text = recipe.name
        linkTextField.text = recipe.link
        descriptionTextView.text = recipe.description
    }
    
    func setupStyling() {
        Style.styleTextField(nameTextField)
        Style.styleTextField(linkTextField)
        Style.styleFilledButton(saveButton)
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if (error != nil) {
            showError(error!)
            return
        }
        
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let link = linkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let description = descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        db.collection("recipes").document(self.recipe!.id).updateData(["name" : name!, "link" : link!, "description" : description!, "approved" : false]) {
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
