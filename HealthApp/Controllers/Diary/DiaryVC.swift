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
   
    @IBOutlet var btnWater: [UIButton]!
    @IBOutlet weak var caloriesBar: MBCircularProgressBarView!
    @IBOutlet weak var waterBar: MBCircularProgressBarView!
    @IBOutlet weak var eatenLabel: UILabel!
    @IBOutlet weak var drunkLabel: UILabel!
    @IBOutlet weak var burnLablel: UILabel!
    @IBOutlet var btnFood: [UIButton]!

    @IBOutlet weak var ExerciseLabelUIView: UIView!
    var eaten = 0
    var calo  = 0
    var water = 0
    var drunk = 0
    var dataFromDetail = [(name: String, cal: Int , mode : Int)]()
    //biến ref lấy data ng dùng từ firebase
    var ref: DatabaseReference!
    override func viewDidLoad() {
        getInfo()
        
        super.viewDidLoad()
        underlined()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.tabBarController?.tabBar.isHidden = false
        
        
    }
    func underlined(){
        
        
        self.ExerciseLabelUIView.layer.masksToBounds = false
        self.ExerciseLabelUIView.layer.shadowColor = UIColor.black.cgColor
        self.ExerciseLabelUIView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.ExerciseLabelUIView.layer.shadowOpacity = 1.0
        self.ExerciseLabelUIView.layer.shadowRadius = 0.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        setUp()
    }
   
    func getInfo() {
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child("need").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                self.calo = values?["Calo"] as? Int ?? 0
                self.water = values?["Water(ml)"] as? Int ?? 0
                self.caloriesBar.value = CGFloat(self.calo)
                self.waterBar.value = CGFloat(self.water)
                
            }
        }
    }
    func setUp() {
        if drunk != 0 {
            if drunk * 250 >= water {
                let overWater =  drunk * 250 - water
                self.waterBar.value = CGFloat(overWater)
                self.waterBar.maxValue = CGFloat(overWater)
                self.waterBar.unitString = "ML over"
            }
            else {
                let leftWater = water - drunk * 250
                self.waterBar.value = CGFloat(leftWater)
                let ratio = Float(water) / Float(drunk * 250)
                let tmpWater = ratio * Float(leftWater)
                self.waterBar.maxValue = CGFloat(tmpWater)
                self.waterBar.unitString = "ML left"
                
            }
            drunkLabel.text = "Drunk: " + String(drunk * 250)
        }
        
        if eaten != 0 {
            if eaten >= calo {
                let overCalo = eaten - calo
                self.caloriesBar.value = CGFloat(overCalo)
                self.caloriesBar.maxValue = CGFloat(overCalo)
                self.caloriesBar.unitString = "CAL over"
            }
            else {
                let leftCalo = calo - eaten
                self.caloriesBar.value = CGFloat(leftCalo)
                let ratio = Float(calo) / Float(eaten)
                let tmpCalo = ratio * Float(leftCalo)
                self.caloriesBar.maxValue = CGFloat(tmpCalo)
                self.caloriesBar.unitString = "CAL left"
                
            }
            eatenLabel.text = "Eaten: " + String(eaten)
        }
        
    }



    
    @IBAction func tappedWaterGlass(_ sender: UIButton) {
        drunk = sender.tag
        for button in btnWater {
            if button.tag <= drunk{
                button.setImage(#imageLiteral(resourceName: "icons8-bottle_of_water-1"), for: .normal)
            }
            else {
                button.setImage(#imageLiteral(resourceName: "icons8-water_bottle"), for: .normal)
            }
        }
    }
    @IBAction func add1WaterGlass(_ sender: UIButton) {
        drunk += 1
        for button in btnWater {
            if button.tag == drunk {
                button.setImage(#imageLiteral(resourceName: "icons8-bottle_of_water-1"), for: .normal
                )
            }
        }
    }
 
    @IBAction func showBreakfastFoodController(_ sender: UIButton) {
        let temp = sender.tag
        let destination = storyboard?.instantiateViewController(withIdentifier: "BreakfastID")  as! BreakfastVC
         destination.mode = temp
        destination.navigationItem.title = "Breakfast"
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
   
    
    @IBAction func showActivityController(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "ActivityID")  as! ActivityVC
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @IBAction func saveDataFromDetailFood(segue: UIStoryboardSegue){
        if let yasuo = segue.source as? DetailFood {
            let nasus = (yasuo.foodName , yasuo.calories , yasuo.mode)
            self.dataFromDetail.append(nasus)
            eaten += yasuo.calories
            for button in btnFood {
                for i in dataFromDetail {
                    if button.tag == i.mode {
                        button.setImage(nil, for: .normal)
                        button.setTitle("\(i.name) : \(i.cal) Cal", for: .normal)
                    }
                }
            }
        }
    }
    @IBAction func saveDataFromCreateNew(segue: UIStoryboardSegue){
        if let yasuo = segue.source as? popUpViewController {
            let nasus = (yasuo.titleText.text , Int(yasuo.caloriesText.text!)! , yasuo.mode)
            self.dataFromDetail.append(nasus as! (name: String, cal: Int, mode: Int))
            eaten += Int(yasuo.caloriesText.text!)!
            for button in btnFood {
                for i in dataFromDetail {
                    if button.tag == i.mode {
                        button.setImage(nil, for: .normal)
                        button.setTitle("\(i.name) : \(i.cal) Cal", for: .normal)
                    }
                }
            }
        }
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

