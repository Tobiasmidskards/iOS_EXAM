//
//  StylesViewController.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 26/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import UIKit
import Firebase

class StylesViewController: UIViewController {
    
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var styles = [FoodStyle]()
    
    var db : Firestore!
    var vSpinner : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        stylesTableView.delegate = self
        stylesTableView.dataSource = self
        
        setupStyles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getStyles()
    }
    
    func getStyles() {
        styles.removeAll()
        showSpinner(onView: self.view)
        db.collection("styles").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let currentStyle = FoodStyle(id: document.documentID , name: document.data()["name"] as! String)
                    self.styles.append(currentStyle)
                }
                
            }
            self.stylesTableView.reloadData()
            self.removeSpinner()
        }
    }
    
    func setupStyles() {
        Style.styleFilledButton(newButton)
        Style.styleHollowButton(backButton)
    }
    
    @IBAction func newButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier : "NewStyleVC") as! NewStyleViewController
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
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

extension StylesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: Constants.StoryBoard.showStyleViewController) as! ShowStyleViewController
        
        vc.style = styles[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension StylesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = styles[indexPath.row].name
        
        return cell
    }
    
    
}
