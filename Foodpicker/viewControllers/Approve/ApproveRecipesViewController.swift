//
//  ApproveRecipesViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 28/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class ApproveRecipesViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var recipesTableView: UITableView!
    
    var db : Firestore!
    var recipes = [Recipe]()
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipesTableView.delegate = self
        recipesTableView.dataSource = self
        
        db = Firestore.firestore()
        
        setupStyling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUnapprovedRecipes()
    }
    
    func setupStyling() {
        Style.styleHollowButton(backButton)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getUnapprovedRecipes() {
        showSpinner(onView: self.view)
        recipes.removeAll()
        db.collection("recipes").whereField("approved", isEqualTo: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(querySnapshot!.documents.count)
                    let currentRecipe = Recipe(id: document.documentID , name: document.data()["name"] as! String, link: document.data()["link"] as! String, description: document.data()["description"] as! String, style_id : document.data()["style_id"] as! String, user_id: document.data()["user_id"] as! String)
                    self.recipes.append(currentRecipe)
                }
                
            }
            self.recipesTableView.reloadData()
            self.removeSpinner()
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
    
}

extension ApproveRecipesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.showApproveRecipeViewController) as! ShowApproveRecipeViewController
        
        vc.recipe = recipes[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ApproveRecipesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = recipes[indexPath.row].name
        
        return cell
    }
    
    
}
