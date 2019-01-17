//
//  BodyStatsVC.swift
//  HealthApp
//
//  Created by Hồ  Huy on 1/7/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit
import Firebase
class BodyStatsVC: UIViewController {

    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblBMI: UILabel!
    var currentWeight :Float = 0
    var currentHeight :Float = 0
    var currentBMI :Float = 0
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "BODY STATS"
        ref = Database.database().reference()
        self.tabBarController?.tabBar.isHidden = true
        if let data = Auth.auth().currentUser?.uid {
            print(data)
            ref.child(data).child("info").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                
                self.currentWeight = values?["Weight"] as? Float ?? 0
                self.lblWeight.text = String(self.currentWeight) + " kg"
                self.currentHeight = values?["Height"] as? Float ?? 0
                self.lblHeight.text = String(self.currentHeight) + " cm"
                let temp = (Float)(self.currentHeight) / 100
                self.currentBMI = (Float ) (self.currentWeight / (temp * temp))
                self.lblBMI.text = String(format: "%.2f", self.currentBMI)
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func showMeasurementsVC(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "MenuInputSrc")
        show(destination!, sender: nil)
        //self.navigationController?.pushViewController(destination, animated: true)
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
