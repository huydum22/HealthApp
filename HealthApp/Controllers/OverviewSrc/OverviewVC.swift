//
//  OverviewVC.swift
//  HealthApp
//
//  Created by Hồ  Huy on 1/6/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit
import Firebase

class OverviewVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            print(data)
            ref.child(data).child("info").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                
                let name = values?["Name"] as? String ?? ""
              
                self.lblName.text = name
                
                let age = values?["Age"] as? Int ?? 0
                let tuoi  = "Age: " + String(age)
                self.lblAge.text = tuoi
              
            }
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false

    }
    
    @IBAction func UpgradeTapped(_ sender: UIButton) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "Premium")
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    
    @IBAction func BodyTapped(_ sender: UIButton) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "BodyStats")
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    @IBAction func settingTapped(_ sender: UIButton) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "setting")
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
