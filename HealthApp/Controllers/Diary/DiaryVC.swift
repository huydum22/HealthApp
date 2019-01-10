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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var lblBeakfast: UILabel!
    @IBOutlet weak var lblLunch: UILabel!
    @IBOutlet weak var lblDinner: UILabel!
    
    @IBOutlet weak var lblSneck: UILabel!
    
    var eaten = -1
    var calo  = 0
    var water = 0
    var drunk = 0
    var dataFromDetail = [(name: String, cal: Int , mode : Int)]()
    var longGesture = UILongPressGestureRecognizer()
    var idButton = 0
    
    
    
    //biến ref lấy data ng dùng từ firebase
    var ref: DatabaseReference!
    override func viewDidLoad() {
        datePicker.addTarget(self, action: #selector(DiaryVC.dateChanged(datePicker:)), for: .valueChanged)
        btnDate.setTitle(getday(), for: .normal)
        getDBbreakfast()
        getDBlunch()
        getDBdinner()
        getDBsnack()
        setUp()
        getInfo()
        setUpLongPressGesture()
        setUpDataFormDetailArr()
        print("\(drunk) and \(eaten) and \(calo)")
        super.viewDidLoad()
        let ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
           
            ref.child(data).child("need").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let calo1 = values?["Calo"] as? Int   ?? 0
                let sang1 = Double (calo1) * 0.25
                self.lblBeakfast.text = "Recommended " + String(Int (Double (calo1) * 0.25)) + "- " + String(Int(Double (calo1) * 0.35)) + " Kcal"
                self.lblLunch.text = "Recommended " + String(Int (Double (calo1) * 0.3)) + "- " + String(Int(Double (calo1) * 0.4)) + " Kcal"
                self.lblDinner.text = "Recommended " + String(Int (Double (calo1) * 0.4)) + "- " + String(Int(Double (calo1) * 0.5)) + " Kcal"
                self.lblSneck.text = "Recommended " + String(Int (Double (calo1) * 0)) + "- " + String(Int(Double (calo1) * 0.2)) + " Kcal"
            }
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drunk = DRUNK
        eaten = EATEN
        calo = CALO
        print("\(drunk) and \(eaten) and \(calo)")
        showGlass()
        updateCaloriesFromFood()
        getDBbreakfast()
        getDBlunch()
        getDBdinner()
        getDBsnack()
    }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLayoutSubviews() {
        showGlass()
        updateCaloriesFromFood()
        setUp()
        getDBbreakfast()
        getDBlunch()
        getDBdinner()
        getDBsnack()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    
    
    
    func setUpDataFormDetailArr() {
        for i in 1 ... 4 {
            dataFromDetail.append(("",0,i))
        }
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
        
        if eaten >= 0 {
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
    
    func getDBbreakfast ()
    {
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child((btnDate.titleLabel?.text)!).child("breakfast").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let temp = values?["Breakfast"] as? String   ?? ""
                if temp != ""
                {
                    self.btnFood[0].setImage(nil, for: .normal)
                    self.btnFood[0].setTitle(temp, for: .normal)
                }
                else
                {
                    self.btnFood[0].setImage( #imageLiteral(resourceName: "icons8-bread"), for: .normal)
                    self.btnFood[0].setTitle(nil, for: .normal)
                }
            }
        }
    }
    func getDBlunch ()
    {
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child((btnDate.titleLabel?.text)!).child("lunch").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let temp = values?["Lunch"] as? String   ?? ""
                if temp != ""
                {
                    self.btnFood[1].setImage(nil, for: .normal)
                    self.btnFood[1].setTitle(temp, for: .normal)
                }
                else
                {
                    self.btnFood[1].setImage( #imageLiteral(resourceName: "icons8-chicken"), for: .normal)
                    self.btnFood[1].setTitle(nil, for: .normal)
                }
            }
        }
    }
    func getDBdinner ()
    {
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child((btnDate.titleLabel?.text)!).child("dinner").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let temp = values?["Dinner"] as? String   ?? ""
                if temp != ""
                {
                    self.btnFood[2].setImage(nil, for: .normal)
                    self.btnFood[2].setTitle(temp, for: .normal)
                }
                else
                {
                    self.btnFood[2].setImage( #imageLiteral(resourceName: "icons8-fish_food"), for: .normal)
                    self.btnFood[2].setTitle(nil, for: .normal)
                }
            }
        }
    }
    func getDBsnack ()
    {
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child((btnDate.titleLabel?.text)!).child("snack").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let temp = values?["Snack"] as? String   ?? ""
                if temp != ""
                {
                    self.btnFood[3].setImage(nil, for: .normal)
                    self.btnFood[3].setTitle(temp, for: .normal)
                }
                else
                {
                    self.btnFood[3].setImage( #imageLiteral(resourceName: "icons8-mcdonalds_french_fries"), for: .normal)
                    self.btnFood[3].setTitle(nil, for: .normal)
                }
            }
        }
    }
    
    
    func showGlass ()
    {
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child((btnDate.titleLabel?.text)!).child("water").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                
                self.drunk = values?["Water"] as? Int   ?? 0
                
            }
        }
        for button in btnWater {
            if button.tag <= drunk{
                button.setImage( #imageLiteral(resourceName: "icons8-bottle_of_water-1"), for: .normal)
            }
            else {
                button.setImage( #imageLiteral(resourceName: "icons8-water_bottle"), for: .normal)
            }
        }
    }
    
    func updateCaloriesFromFood() {
        
        
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                
                self.eaten = values?["Eaten"] as? Int   ?? 0
                
            }
        }
    }
    
    
    
    @IBAction func dateTapped(_ sender: UIButton) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1) {
            self.datePicker.isHidden = !self.datePicker.isHidden
            self.view.layoutIfNeeded()
        }
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func tappedWaterGlass(_ sender: UIButton) {
        drunk = sender.tag
        showGlass()
        ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("water").setValue(["Water":drunk])
    }
    @IBAction func add1WaterGlass(_ sender: UIButton) {
        drunk += 1
        for button in btnWater {
            if button.tag == drunk {
                button.setImage( #imageLiteral(resourceName: "icons8-bottle_of_water-1"), for: .normal)
                
            }
        }
        ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("water").setValue(["Water":drunk])
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
    
    @IBAction func saveDataFromDetailFood(segue: UIStoryboardSegue){
        if let yasuo = segue.source as? DetailFood {
            let nasus = (yasuo.foodName , yasuo.calories , yasuo.mode)
            self.dataFromDetail.insert(nasus, at: yasuo.mode - 1 )
            self.dataFromDetail.remove(at: yasuo.mode )
            updateCaloriesFromFood()
            ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eaten])
            for button in btnFood {
                for i in dataFromDetail {
                    if button.tag == i.mode && i.name != "" {
                        button.setImage(nil, for: .normal)
                        button.setTitle("\(i.name) : \(i.cal) Cal", for: .normal)
                    }
                }
            }
            switch yasuo.mode {
            case 1:
                ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("breakfast").setValue(["Breakfast":"\(nasus.0) : \(nasus.1)"])
            case 2:                ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("lunch").setValue(["Lunch":"\(nasus.0) : \(nasus.1)"])
            case 3:                ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("dinner").setValue(["Dinner":"\(nasus.0) : \(nasus.1)"])
            case 4:
                ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("snack").setValue(["Snack":"\(nasus.0) : \(nasus.1)"])
            default: break
                
                
            }
        }
    }
    @IBAction func saveDataFromCreateNew(segue: UIStoryboardSegue){
        if let yasuo = segue.source as? popUpViewController {
            let nasus = (yasuo.titleText.text , Int(yasuo.caloriesText.text!) ?? 0 , yasuo.mode)
            self.dataFromDetail.insert(nasus as! (name: String, cal: Int, mode: Int),at: yasuo.mode - 1 )
            self.dataFromDetail.remove(at: yasuo.mode)
            updateCaloriesFromFood()
            ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eaten])
            for button in btnFood {
                for i in dataFromDetail {
                    if button.tag == i.mode && i.name != "" {
                        button.setImage(nil, for: .normal)
                        button.setTitle("\(i.name) : \(i.cal) Cal", for: .normal)
                    }
                }
            }
            switch yasuo.mode {
            case 1:
                ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("breakfast").setValue(["Breakfast":"\(String(describing: nasus.0 )) : \(nasus.1)"])
            case 2:                ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("lunch").setValue(["Lunch":"\(String(describing: nasus.0)) : \(nasus.1)"])
            case 3:                ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("dinner").setValue(["Dinner":"\(String(describing: nasus.0)) : \(nasus.1)"])
            case 4:
                ref.child((Auth.auth().currentUser?.uid)!).child((btnDate.titleLabel?.text)!).child("snack").setValue(["Snack":"\(String(describing: nasus.0)) : \(nasus.1)"])
            default: break
                
            }
        }
    }
    
    func deleteFood(alert: UIAlertAction!) {
        switch idButton {
        case 1:
            btnFood[idButton-1].setImage( #imageLiteral(resourceName: "icons8-bread"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,1), at: idButton-1)
            dataFromDetail.remove(at: idButton)
        case 2:
            btnFood[idButton-1].setImage( #imageLiteral(resourceName: "icons8-chicken"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,2), at: idButton-1)
            dataFromDetail.remove(at: idButton)
        case 3:
            btnFood[idButton-1].setImage( #imageLiteral(resourceName: "icons8-fish_food"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,3), at: idButton-1)
            dataFromDetail.remove(at: idButton)
        case 4:
            btnFood[idButton-1].setImage( #imageLiteral(resourceName: "icons8-mcdonalds_french_fries"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,4), at: idButton-1)
            dataFromDetail.remove(at: idButton)
        default:
            btnFood[4].setImage(#imageLiteral(resourceName: "icons8-climbing-shoes-48"), for: .normal)
            btnFood[4].setTitle(nil, for: .normal)
        }
        updateCaloriesFromFood()
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
    
    @objc func dateChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        btnDate.setTitle(dateFormatter.string(from: datePicker.date), for: .normal)
        btnDate.setTitleColor(UIColor.black, for: .normal)
        view.endEditing(true)
    }
    func getday()->String{
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        var dday = String(day)
        var mmonth = String(month)
        if day < 10{
            dday = "0"+String(day)
        }
        if month < 10 {
            mmonth = "0"+String(month)
        }
        let getADay:String = dday+"-"+mmonth+"-"+String(year)
        return getADay
    }
}

