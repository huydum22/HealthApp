//
//  OverviewController.swift
//  HealthApp
//
//  Created by Ho Huy on 12/3/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class OverviewVC: UIViewController ,  UITableViewDelegate , UITableViewDataSource{
    
    let arrMenuBarText = ["        Goal","        Weight","        Water","        Diary" , "        Foods" , "        Activity"]
    let imgMenuIcon = [#imageLiteral(resourceName: "icons8-goal"),#imageLiteral(resourceName: "icons8-weight"),#imageLiteral(resourceName: "icons8-water"),#imageLiteral(resourceName: "icons8-copybook"),#imageLiteral(resourceName: "icons8-vegetarian_food"), #imageLiteral(resourceName: "icons8-weightlift")]
    var openMenuBar = true
    @IBOutlet weak var sideMenuBar: NSLayoutConstraint!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenuBarText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        cell.lblIconMenu.text = arrMenuBarText[indexPath.row]
        cell.imageView?.image = imgMenuIcon[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var seque = storyboard?.instantiateInitialViewController()
        if indexPath.row == 0 {
            seque = storyboard?.instantiateViewController(withIdentifier: "GoalID") as! GoalVC
        }
        if indexPath.row == 1 {
            seque = storyboard?.instantiateViewController(withIdentifier: "WeightID") as! WeightVC
        }
        if indexPath.row == 2 {
            seque = storyboard?.instantiateViewController(withIdentifier: "WaterID") as! WaterVC
        }
        if indexPath.row == 3 {
            seque = storyboard?.instantiateViewController(withIdentifier: "DiaryID") as! DiaryVC
        }
        if indexPath.row == 4 {
            seque = storyboard?.instantiateViewController(withIdentifier: "FoodID") as! FoodVC
        }
        if indexPath.row == 5 {
            seque = storyboard?.instantiateViewController(withIdentifier: "ActivityID") as! ActivityVC
        }
        self.navigationController?.pushViewController(seque!, animated: true)
    }
    
var dataUser :Person!
    @IBOutlet weak var hiUser: UILabel!
    let userDefault = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        hiUser.text = dataUser.Name
         sideMenuBar.constant = -250
    }
    
    @IBAction func isOpenMenuBar(_ sender: Any) {
        if openMenuBar {
            openMenuBar = false
            sideMenuBar.constant = 0
        }
        else
        {
            openMenuBar = true
            sideMenuBar.constant = -250
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func SignOut(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            userDefault.set(false, forKey: "UserLogined")
            userDefault.synchronize()
            self.dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    

}
