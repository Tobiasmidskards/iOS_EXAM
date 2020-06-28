//
//  ChallengeViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 25/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class ChallengeViewController: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var firstContestantButton: UIButton!
    @IBOutlet weak var secondContestantButton: UIButton!
    
    @IBOutlet weak var resultTitleLable: UILabel!
    @IBOutlet weak var resultStyleLabel: UILabel!
    @IBOutlet weak var resultRecipeNameLabel: UILabel!
    @IBOutlet weak var resultRecipeDescription: UITextView!
    @IBOutlet weak var goToRecipeButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonTwo: UIButton!
    
    var vSpinner : UIView?
    var db: Firestore!
    
    var foodStyles = [FoodStyle]()
    var currentContestants = [FoodStyle]()
    var resultRecipes = [Recipe]()
    var resultRecipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        setupStyling()
        getFoodStyles()
    }
    
    func setupStyling()
    {
        Style.styleFilledButton(firstContestantButton)
        Style.styleFilledSecondaryButton(secondContestantButton)
        
        Style.styleFilledButton(goToRecipeButton)
        Style.styleFilledSecondaryButton(shuffleButton)
        Style.styleFilledThirdButton(tryAgainButton)
        Style.styleHollowButton(backButton)
        Style.styleHollowButton(backButtonTwo)
        
        infoLabel.isHidden = false
        firstContestantButton.isHidden = false
        secondContestantButton.isHidden = false
        backButtonTwo.isHidden = false
        
        resultStyleLabel.isHidden = true
        resultRecipeNameLabel.isHidden = true
        resultRecipeDescription.isHidden = true
        tryAgainButton.isHidden = true
        shuffleButton.isHidden = true
        goToRecipeButton.isHidden = true
        resultTitleLable.isHidden = true;
        backButton.isHidden = true
    }
    
    func setupResultStyles() {
        infoLabel.isHidden = true
        firstContestantButton.isHidden = true
        secondContestantButton.isHidden = true
        backButtonTwo.isHidden = true
        
        resultTitleLable.isHidden = false;
        resultStyleLabel.isHidden = false
        resultRecipeNameLabel.isHidden = false
        resultRecipeDescription.isHidden = false
        resultRecipeDescription.isEditable = false;
        resultRecipeDescription.isSelectable = false;
        
        tryAgainButton.isHidden = false
        shuffleButton.isHidden = false
        goToRecipeButton.isHidden = false
        backButton.isHidden = false
    }
    
    func getFoodStyles() {
        foodStyles.removeAll()
        currentContestants.removeAll()
        self.showSpinner(onView: self.view)
        self.db.collection("styles").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let currentStyle = FoodStyle(id: document.documentID , name: document.data()["name"] as! String)
                    self.foodStyles.append(currentStyle)
                }
                
            }
            self.nextChallenge(looser: nil)
            self.removeSpinner()
        }
    }
    
    func getRecipe() {
        let style = foodStyles[0]
        resultRecipe = nil
        self.showSpinner(onView: self.view)
        self.db.collection("recipes").whereField("style_id", isEqualTo: style.id).whereField("approved", isEqualTo: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.resultRecipes = [Recipe]()
                for document in querySnapshot!.documents {
                    let recipe = Recipe(id: document.documentID, name: document.data()["name"] as! String, link : document.data()["link"] as! String, description: document.data()["description"] as! String, style_id: document.data()["style_id"] as! String, user_id: document.data()["user_id"] as! String)
                    self.resultRecipes.append(recipe)
                }
                
                if let winner = self.resultRecipes.randomElement() {
                    self.resultRecipe = winner
                }
                
            }
            
            if (self.resultRecipe != nil) {
                self.setupResultStyles()
                self.resultStyleLabel.text = style.name
                self.resultRecipeNameLabel.text = self.resultRecipe.name
                self.resultRecipeDescription.text = self.resultRecipe.description
            } else {
                print("no recipes found")
                self.navigationController?.popViewController(animated: true)
            }
            
            self.removeSpinner()
        }
    }
    
    func showResult() {
        getRecipe()
    }
    
    func nextChallenge(looser: FoodStyle?) {
        let firstContestant:FoodStyle
        var secondContestant:FoodStyle
        currentContestants.removeAll()
        
        if (foodStyles.count < 1) {
            print("Not enough styles..")
            return
        }
        
        if (looser != nil) {
            let index = foodStyles.firstIndex(where: {$0.id == looser!.id})
            foodStyles.remove(at: index!)
        }
        
        if (foodStyles.count < 2) {
            showResult()
            return
        }
        
        firstContestant = foodStyles.randomElement()!
        secondContestant = firstContestant
        
        while (firstContestant.id == secondContestant.id) {
            secondContestant = foodStyles.randomElement()!
        }
        
        currentContestants.append(firstContestant)
        currentContestants.append(secondContestant)
        
        firstContestantButton.setTitle(firstContestant.name, for: .normal)
        secondContestantButton.setTitle(secondContestant.name, for: .normal)
    }
    
    @IBAction func firstContestantButtonTapped(_ sender: Any) {
        nextChallenge(looser: currentContestants[1])
    }
    
    @IBAction func secondContestantButtonTapped(_ sender: Any) {
        nextChallenge(looser: currentContestants[0])
    }
    @IBAction func shuffleButtonTapped(_ sender: Any) {
        getRecipe()
    }
    
    @IBAction func tryAgainButtonTapped(_ sender: Any) {
        setupStyling()
        getFoodStyles()
    }
    
    @IBAction func goToRecipeButtonTapped(_ sender: Any) {
        if (resultRecipe != nil) {
            guard let url = URL(string: resultRecipe.link) else { return }
            UIApplication.shared.open(url)
        }
        
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
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonTwoTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
}
