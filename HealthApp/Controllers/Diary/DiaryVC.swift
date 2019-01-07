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
    var eaten = 0
    var calo  = 0
    var water = 0
    var drunk = 0
    var dataFromDetail = [(name: String, cal: Int , mode : Int)]()
    var longGesture = UILongPressGestureRecognizer()
    var idButton = 0
    //biến ref lấy data ng dùng từ firebase
    var ref: DatabaseReference!
    override func viewDidLoad() {
        getInfo()
        setUpLongPressGesture()
       setUpDataFormDetailArr()
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false

        // Do any additional setup after loading the view.
    }
    func setUpDataFormDetailArr() {
        for i in 1 ... 4 {
            dataFromDetail.append(("",0,i))
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        setUp()
    }
   func setUpLongPressGesture() {
        for button in btnFood {
            longGesture = UILongPressGestureRecognizer(target: self, action: #selector(DiaryVC.handleGesture(_:)))
            longGesture.minimumPressDuration = 0.5
            button.addGestureRecognizer(longGesture)
        }
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
        let destination = storyboard?.instantiateViewController(withIdentifier: "BreakfastID")  as! BreakfastVC
         destination.mode = idButton
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
   
    
    @IBAction func showActivityController(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "ActivityID")  as! ActivityVC
        
        self.navigationController?.pushViewController(destination, animated: true)
    }
    func updateCaloriesFromFood() {
        eaten = 0
        for i in dataFromDetail {
            eaten += i.cal
        }
    }
    @IBAction func saveDataFromDetailFood(segue: UIStoryboardSegue){
        if let yasuo = segue.source as? DetailFood {
            let nasus = (yasuo.foodName , yasuo.calories , yasuo.mode)
            self.dataFromDetail.insert(nasus, at: yasuo.mode - 1 )
            self.dataFromDetail.remove(at: yasuo.mode )
            updateCaloriesFromFood()
            for button in btnFood {
                for i in dataFromDetail {
                    if button.tag == i.mode && i.name != "" {
                        button.setImage(nil, for: .normal)
                        button.setTitle("\(i.name) : \(i.cal) Cal", for: .normal)
                    }
                }
            }
        }
    }
    @IBAction func saveDataFromCreateNew(segue: UIStoryboardSegue){
        if let yasuo = segue.source as? popUpViewController {
            let nasus = (yasuo.titleText.text , Int(yasuo.caloriesText.text!) ?? 0 , yasuo.mode)
            self.dataFromDetail.insert(nasus as! (name: String, cal: Int, mode: Int),at: yasuo.mode - 1 )
            self.dataFromDetail.remove(at: yasuo.mode)
          updateCaloriesFromFood()
            for button in btnFood {
                for i in dataFromDetail {
                    if button.tag == i.mode && i.name != "" {
                        button.setImage(nil, for: .normal)
                        button.setTitle("\(i.name) : \(i.cal) Cal", for: .normal)
                    }
                }
            }
        }
    }
    
    func deleteFood(alert: UIAlertAction!) {
        switch idButton {
        case 1:
            btnFood[idButton-1].setImage(#imageLiteral(resourceName: "icons8-bread"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,1), at: idButton-1)
            dataFromDetail.remove(at: idButton)
        case 2:
            btnFood[idButton-1].setImage(#imageLiteral(resourceName: "icons8-chicken"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,2), at: idButton-1)
            dataFromDetail.remove(at: idButton)
        case 3:
            btnFood[idButton-1].setImage(#imageLiteral(resourceName: "icons8-fish_food"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,3), at: idButton-1)
            dataFromDetail.remove(at: idButton)
        case 4:
            btnFood[idButton-1].setImage(#imageLiteral(resourceName: "icons8-mcdonalds_french_fries"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,4), at: idButton-1)
            dataFromDetail.remove(at: idButton)
        default:
            btnFood[4].setImage(#imageLiteral(resourceName: "icons8-climbing-shoes-48"), for: .normal)
            btnFood[4].setTitle(nil, for: .normal)
        }
        print(dataFromDetail)
        print(eaten)
        updateCaloriesFromFood()
        print(eaten)
    }
    @objc func handleGesture(_ sender: UILongPressGestureRecognizer) {
            let alertController = UIAlertController(title: "DELETE", message:
                "Are you sure you want to delete this item ?", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default,handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: deleteFood))
            self.present(alertController, animated: true, completion: nil)
    }
    

  
    @IBAction func identifyButton(_ sender: UIButton) {
        idButton = sender.tag
    }
    
}
