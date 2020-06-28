//
//  NewStyleViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 26/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class NewStyleViewController: UIViewController, UITextFieldDelegate  {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        db = Firestore.firestore()
        setupStyling()
    }
    
    func setupStyling() {
        Style.styleTextField(nameTextField)
        Style.styleFilledButton(addButton)
        Style.styleHollowButton(backButton)
        errorLabel.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        guard let text = nameTextField.text, !text.isEmpty else {
            return
        }
        
        db.collection("styles").addDocument(data: ["name" : text]) {
            (err) in if err != nil {
                print("Something went wrong..")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
}
