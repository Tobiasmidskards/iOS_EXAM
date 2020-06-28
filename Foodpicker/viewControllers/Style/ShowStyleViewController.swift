//
//  ShowStyleViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 26/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class ShowStyleViewController: UIViewController {
    
    @IBOutlet weak var styleNameLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var recipesButton: UIButton!
    
    var style : FoodStyle?
    var db : Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        styleNameLabel.text = style?.name
    }
    
    func setupStyles() {
        Style.styleTextField(styleNameLabel)
        Style.styleFilledThirdButton(deleteButton)
        Style.styleFilledSecondaryButton(saveButton)
        Style.styleHollowButton(backButton)
        Style.styleFilledButton(recipesButton)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let text = styleNameLabel.text, !text.isEmpty else {
            return
        }
        
        db.collection("styles").document(style!.id).updateData(["name" : text]) {
            (err) in if err != nil {
                print("Something went wrong..")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        db.collection("styles").document(style!.id).delete() {
            err in if err != nil {
                print("Something went wrong")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func recipesButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.recipesViewController) as! RecipesViewController
        
        vc.style = style
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
