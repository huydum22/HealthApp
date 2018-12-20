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

class OverviewVC: UIViewController {
    
    var ref: DatabaseReference!
    var openMenuBar = true
    @IBOutlet var viewController: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblGoalWeight: UILabel!
    
    
    let userDefault = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            print(data)
            ref.child(data).child("info").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                
                let name1 = values?["Name"] as? String ?? ""
                let name  = "hi " + name1
                self.lblName.text = name
                
                let age = values?["Age"] as? Int ?? 0
                self.lblAge.text = String(age)
                
                let height = values?["Height"] as? Float ?? 0
                self.lblHeight.text = String(height) + " (cm)"
                
                let weight = values?["Weight"] as? Float ?? 0
                self.lblWeight.text = String(weight) + " (kg)"
                
                let goalWeight = values?["Goal weight"] as? Float ?? 0
                self.lblGoalWeight.text = String(goalWeight) + " (kg)"
            }
        }
    }
    
    
    @IBAction func SignOut(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            userDefault.set(false, forKey: "UserLogined")
            userDefault.set(false, forKey: "NewUser")
            userDefault.set(false, forKey: "OldUser")
            userDefault.synchronize()
            self.dismiss(animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func Update(_ sender: Any) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "MenuInputSrc")
        present(destination!, animated: true, completion: nil)
    }
    
    
    
}
