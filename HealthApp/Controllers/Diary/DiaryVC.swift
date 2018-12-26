//
//  DiaryVC.swift
//  HealthApp
//
//  Created by Ho Huy on 12/4/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import Firebase
class DiaryVC: UIViewController {

    var number = 0
    var ref: DatabaseReference!
    override func viewDidLoad() {
        ref = Database.database().reference()
         if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child("need").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let calo = values?["Calo"] as? Int ?? 0
                
                let water = values?["Water(ml)"] as? Int ?? 0
                self.caloriesBar.value = CGFloat(calo)
                self.waterBar.value = CGFloat(water)
                
            }
        }
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet var btnWater: [UIButton]!
    @IBOutlet weak var caloriesBar: MBCircularProgressBarView!
    
    @IBOutlet weak var waterBar: MBCircularProgressBarView!
    
    
    
    
    @IBAction func tappedWaterGlass(_ sender: UIButton) {
        number = sender.tag
        for button in btnWater {
            if button.tag <= number{
                button.setImage(#imageLiteral(resourceName: "icons8-bottle_of_water-1"), for: .normal)
            }
            else {
                button.setImage(#imageLiteral(resourceName: "icons8-water_bottle"), for: .normal)
            }
        }
    }
    @IBAction func add1WaterGlass(_ sender: UIButton) {
        number = number + 1
        for button in btnWater {
            if button.tag == number {
                button.setImage(#imageLiteral(resourceName: "icons8-bottle_of_water-1"), for: .normal
                )
            }
        }
    }
    
    @IBAction func showFoodController(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "BreakfastID")  as! BreakfastVC
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @IBAction func showActivityController(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "ActivityID")  as! ActivityVC
        
        self.navigationController?.pushViewController(destination, animated: true)
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
