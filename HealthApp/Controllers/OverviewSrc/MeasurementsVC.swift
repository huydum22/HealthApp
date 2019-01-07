//
//  MeasurementsVC.swift
//  HealthApp
//
//  Created by Hồ  Huy on 1/7/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit
import Firebase
class MeasurementsVC: UIViewController {

    @IBOutlet weak var lblCurrentWei: UILabel!
    @IBOutlet weak var lblCurrentHei: UILabel!
    @IBOutlet weak var lblCurrentBMI: UILabel!
    
    
    var wei : Float = 0
    var hei : Float = 0
    var bmi :Float = 0
    var name = ""
    var sex = ""
    var age = 0
    var goalweight = 0
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "NEW MEASUREMENTS"
        lblCurrentWei.text = String(wei) + " kg"
        lblCurrentHei.text = String(hei) + " cm"
        lblCurrentBMI.text = String(bmi)
       
        
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
