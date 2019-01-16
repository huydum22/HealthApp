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
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var pushLabel: UILabel!
    @IBOutlet weak var disLabel: UILabel!
    
    
    
    @IBOutlet var btnFood: [UIButton]!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var lblBeakfast: UILabel!
    @IBOutlet weak var lblLunch: UILabel!
    @IBOutlet weak var lblDinner: UILabel!
    @IBOutlet weak var lblSneck: UILabel!
    @IBOutlet weak var heightOverView: NSLayoutConstraint!
    @IBOutlet weak var heightBreak: NSLayoutConstraint!
    @IBOutlet weak var heightBtnBreak: NSLayoutConstraint!
    
    var eaten = -1
    var calo  = 0
    var water = 0
    var drunk = 0
    var burn = 0
    var step = 0
    var push = 0
    var distancce = 0
    var dataFromDetail = [(name: String, cal: Int , mode : Int)]()
    var longGesture = UILongPressGestureRecognizer()
    var idButton = 0
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        datePicker.addTarget(self, action: #selector(DiaryVC.dateChanged(datePicker:)), for: .valueChanged)
        btnDate.setTitle(getday(), for: .normal)
        setUp()
        getInfo()
        updateCaloriesFromFood()
        setUpLongPressGesture()
        setUpDataFormDetailArr()
        print("\(drunk) and \(eaten) and \(calo)")
        super.viewDidLoad()
        let ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
           
            ref.child(data).child("need").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let calo1 = values?["Calo"] as? Int   ?? 0
                self.lblBeakfast.text = "Recommended " + String(Int (Double (calo1) * 0.25)) + "- " + String(Int(Double (calo1) * 0.35)) + " Kcal"
                self.lblLunch.text = "Recommended " + String(Int (Double (calo1) * 0.3)) + "- " + String(Int(Double (calo1) * 0.4)) + " Kcal"
                self.lblDinner.text = "Recommended " + String(Int (Double (calo1) * 0.4)) + "- " + String(Int(Double (calo1) * 0.5)) + " Kcal"
                self.lblSneck.text = "Recommended " + String(Int (Double (calo1) * 0)) + "- " + String(Int(Double (calo1) * 0.2)) + " Kcal"
            }
        }
       loadlabel()
        self.tabBarController?.tabBar.isHidden = false
        heightBreak.constant += 20
        heightBtnBreak.constant += 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drunk = DRUNK
        eaten = EATEN
        calo = CALO
        burn = BURN
        step = STEP
        distancce = DISTANCE
        push = PUSH
        updateCaloriesFromFood()
        getDBbreakfast()
        getDBlunch()
        getDBdinner()
        getDBsnack()
        loadlabel()
         self.tabBarController?.tabBar.isHidden = false
    }
   
    override func viewDidLayoutSubviews() {
        showGlass()
        updateCaloriesFromFood()
        setUp()
        getDBbreakfast()
        getDBlunch()
        getDBdinner()
        getDBsnack()
        loadlabel()
    }
   

    //MARK: set up Overview
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
    func loadlabel(){
        let ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
        ref.child(data).child("Days").child(getday()).child("burn").observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as? NSDictionary
            
            self.burn = values?["Burn"] as? Int   ?? 0
            
        }
        ref.child(data).child("Days").child(getday()).child("step").observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as? NSDictionary
            
            self.step = values?["Step"] as? Int   ?? 0
            
        }
        ref.child(data).child("Days").child(getday()).child("distance").observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as? NSDictionary
            
            self.distancce = values?["Distance"] as? Int   ?? 0
            
        }
        ref.child(data).child("Days").child(getday()).child("push").observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as? NSDictionary
            
            self.push = values?["Push"] as? Int   ?? 0
            
        }
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
        burnLablel.text = "Burn: " + String(burn)
        stepLabel.text = "Step: " + String(step)
        pushLabel.text = "Push up: " + String (push)
        disLabel.text = "Distance: " + String (distancce)
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
    
    
    
    // MARK: GET data from Firebase
    func getDBbreakfast ()
    {
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("breakfast").observeSingleEvent(of: .value) { (snapshot) in
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
            ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("lunch").observeSingleEvent(of: .value) { (snapshot) in
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
            ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("dinner").observeSingleEvent(of: .value) { (snapshot) in
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
            ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("snack").observeSingleEvent(of: .value) { (snapshot) in
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
    
    
    
    //MARK: show image glass
    func showGlass ()
    {
        ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("water").observeSingleEvent(of: .value) { (snapshot) in
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
            ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                self.eaten = values?["Eaten"] as? Int   ?? 0
            }
        }
    }
    
    
    
    
    //MARk : event
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
        ref.child((Auth.auth().currentUser?.uid)!).child("Days").child((btnDate.titleLabel?.text)!).child("water").setValue(["Water":drunk])
        self.view.layoutIfNeeded()

    }
    @IBAction func add1WaterGlass(_ sender: UIButton) {
        drunk += 1
        for button in btnWater {
            if button.tag == drunk {
                button.setImage( #imageLiteral(resourceName: "icons8-bottle_of_water-1"), for: .normal)
                
            }
        }
        ref.child((Auth.auth().currentUser?.uid)!).child("Days").child((btnDate.titleLabel?.text)!).child("water").setValue(["Water":drunk])
    }
    
    @IBAction func showBreakfastFoodController(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "BreakfastID")  as! BreakfastVC
        destination.mode = idButton
        destination.getday = (btnDate.titleLabel?.text)!
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
    
    @IBAction func showActivityController(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "ActivityID")  as! ActivityVC
        destination.getday = (btnDate.titleLabel?.text)!

        self.navigationController?.pushViewController(destination, animated: true)
    }
    
    @IBAction func saveDataFromDetailFood(segue: UIStoryboardSegue){
        if let yasuo = segue.source as? DetailFood {
            let nasus = (yasuo.foodName , yasuo.calories , yasuo.mode)
            self.dataFromDetail.insert(nasus, at: yasuo.mode - 1 )
            self.dataFromDetail.remove(at: yasuo.mode )
            
            if let data = Auth.auth().currentUser?.uid {
                ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                    let values = snapshot.value as? NSDictionary
                    var eat = values?["Eaten"] as? Int   ?? 0
                    eat = eat + nasus.1
                    self.eaten = eat
                    self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eat])
                    self.view.layoutIfNeeded()                    
                }
            }

            self.view.layoutIfNeeded()

            switch yasuo.mode {
            case 1:
                self.ref.child("\((Auth.auth().currentUser?.uid)!)/Days/\((btnDate.titleLabel?.text)!)/breakfast/Breakfast").setValue("  🍞  \(nasus.0) : \(nasus.1)")
//
                let databaseRef = Database.database().reference().child(((Auth.auth().currentUser?.uid)!)).child("Days").child((btnDate.titleLabel?.text)!).child("breakfast").child("breakfasts")
                let locationRef = databaseRef.childByAutoId()
                locationRef.setValue(["Name":"  🍞  \(nasus.0) : \(nasus.1)"])
            case 2:
                
                self.ref.child("\((Auth.auth().currentUser?.uid)!)/Days/\((btnDate.titleLabel?.text)!)/lunch/Lunch").setValue("  🥩  \(nasus.0) : \(nasus.1)")
                let databaseRef = Database.database().reference().child(((Auth.auth().currentUser?.uid)!)).child("Days").child((btnDate.titleLabel?.text)!).child("lunch").child("lunchs")
                let locationRef = databaseRef.childByAutoId()
                locationRef.setValue(["Name":"  🥩  \(nasus.0) : \(nasus.1)"])
            case 3:
                self.ref.child("\((Auth.auth().currentUser?.uid)!)/Days/\((btnDate.titleLabel?.text)!)/dinner/Dinner").setValue("  🍕  \(nasus.0) : \(nasus.1)")
                let databaseRef = Database.database().reference().child(((Auth.auth().currentUser?.uid)!)).child("Days").child((btnDate.titleLabel?.text)!).child("dinner").child("dinners")
                let locationRef = databaseRef.childByAutoId()
                locationRef.setValue(["Name":"  🍕  \(nasus.0) : \(nasus.1)"])
            case 4:
                  self.ref.child("\((Auth.auth().currentUser?.uid)!)/Days/\((btnDate.titleLabel?.text)!)/snack/Snack").setValue("  🍟  \(nasus.0) : \(nasus.1)")
                  let databaseRef = Database.database().reference().child(((Auth.auth().currentUser?.uid)!)).child("Days").child((btnDate.titleLabel?.text)!).child("snack").child("snacks")
                  let locationRef = databaseRef.childByAutoId()
                  locationRef.setValue(["Name":"  🍟  \(nasus.0) : \(nasus.1)"])
            default: break
            }
            self.view.layoutIfNeeded()

        }
        let alert  = UIAlertController(title: "Congratulations", message: "Update successful", preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveDataFromCreateNew(segue: UIStoryboardSegue){
        
        if let yasuo = segue.source as? popUpViewController {
            let nasus = (yasuo.titleText.text , Int(yasuo.caloriesText.text!) ?? 0 , yasuo.mode)
            self.dataFromDetail.insert(nasus as! (name: String, cal: Int, mode: Int),at: yasuo.mode - 1 )
            self.dataFromDetail.remove(at: yasuo.mode)
            if let data = Auth.auth().currentUser?.uid {
                ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                    let values = snapshot.value as? NSDictionary
                    var eat = values?["Eaten"] as? Int   ?? 0
                    eat = eat + nasus.1
                    self.eaten = eat
                    self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eat])
                    self.view.layoutIfNeeded()
                }
            }
            switch yasuo.mode {
            case 1:
                
                self.ref.child("\((Auth.auth().currentUser?.uid)!)/Days/\((btnDate.titleLabel?.text)!)/breakfast/Breakfast").setValue("  🍞  \(String(describing: nasus.0)) : \(nasus.1)")
                let databaseRef = Database.database().reference().child(((Auth.auth().currentUser?.uid)!)).child("Days").child((btnDate.titleLabel?.text)!).child("breakfast").child("breakfasts")
                let locationRef = databaseRef.childByAutoId()
                locationRef.setValue(["Name":"  🍞  \(String(describing: nasus.0)) : \(nasus.1)"])
            case 2:
               
                self.ref.child("\((Auth.auth().currentUser?.uid)!)/Days/\((btnDate.titleLabel?.text)!)/lunch/Lunch").setValue("  🥩  \(String(describing: nasus.0)) : \(nasus.1)")
                let databaseRef = Database.database().reference().child(((Auth.auth().currentUser?.uid)!)).child("Days").child((btnDate.titleLabel?.text)!).child("lunch").child("lunchs")
                let locationRef = databaseRef.childByAutoId()
                locationRef.setValue(["Name":"  🥩  \(String(describing: nasus.0)) : \(nasus.1)"])
            case 3:
                self.ref.child("\((Auth.auth().currentUser?.uid)!)/Days/\((btnDate.titleLabel?.text)!)/dinner/Dinner").setValue("  🍕  \(String(describing: nasus.0)) : \(nasus.1)")
            let databaseRef = Database.database().reference().child(((Auth.auth().currentUser?.uid)!)).child("Days").child((btnDate.titleLabel?.text)!).child("dinner").child("dinners")
            let locationRef = databaseRef.childByAutoId()
                locationRef.setValue(["Name":"  🍕  \(String(describing: nasus.0)) : \(nasus.1)"])
            case 4:
                self.ref.child("\((Auth.auth().currentUser?.uid)!)/Days/\((btnDate.titleLabel?.text)!)/snack/Snack").setValue("  🍟  \(String(describing: nasus.0)) : \(nasus.1)")
                let databaseRef = Database.database().reference().child(((Auth.auth().currentUser?.uid)!)).child("Days").child((btnDate.titleLabel?.text)!).child("snack").child("snacks")
                let locationRef = databaseRef.childByAutoId()
                locationRef.setValue(["Name":"  🍟  \(String(describing: nasus.0)) : \(nasus.1)"])
            default: break
                
            }
        }
        let alert  = UIAlertController(title: "Congratulations", message: "Update successful", preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveFromExercise(segue: UIStoryboardSegue){
        if let dataEXERCISE = segue.source as? ExerciseInfoVC {
            dataEXERCISE.AddToExerciseRecentList()//thêm vào ExerciseRecentList
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                var eat = values?["Eaten"] as? Int   ?? 0
                eat = eat - (dataEXERCISE.TotalCaloriesBurned + Int(dataEXERCISE.KcaloBurned!))
                self.eaten = eat
           //naskdaskd     self.burnLablel.text = "Burn: " + String(dataEXERCISE.TotalCaloriesBurned + Int(dataEXERCISE.KcaloBurned!))
                self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("burn").observeSingleEvent(of: .value) { (snapshot) in
                    let values = snapshot.value as? NSDictionary
                    var burning = values?["Burn"] as? Int   ?? 0
                    burning = burning + dataEXERCISE.TotalCaloriesBurned + Int(dataEXERCISE.KcaloBurned!)
                    self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("burn").setValue(["Burn":burning])
                    self.view.layoutIfNeeded()
                }
                self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eat])
                self.view.layoutIfNeeded()
            }
        }
            self.view.layoutIfNeeded()

    }
//        let alert  = UIAlertController(title: "Congratulations", message: "Update successful", preferredStyle: .alert)
//        let okAction  = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func exit(segue: UIStoryboardSegue){
    }
    func deleteFood(alert: UIAlertAction!) {
        switch idButton {
        case 1:
            btnFood[idButton-1].setImage( #imageLiteral(resourceName: "icons8-bread"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,1), at: idButton-1)
            dataFromDetail.remove(at: idButton)
            ref.child((Auth.auth().currentUser?.uid)!).child("Days").child((btnDate.titleLabel?.text)!).child("breakfast").removeValue()
            if let data = Auth.auth().currentUser?.uid {
                ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                    let values = snapshot.value as? NSDictionary
                    var eat = values?["Eaten"] as? Int   ?? 0
                    eat = eat - self.dataFromDetail[0].cal
                    self.eaten = eat
                    self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eat])
                    self.view.layoutIfNeeded()
                }
            }
        case 2:
            btnFood[idButton-1].setImage( #imageLiteral(resourceName: "icons8-chicken"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,2), at: idButton-1)
            dataFromDetail.remove(at: idButton)
            ref.child((Auth.auth().currentUser?.uid)!).child("Days").child((btnDate.titleLabel?.text)!).child("lunch").removeValue()
            if let data = Auth.auth().currentUser?.uid {
                ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                    let values = snapshot.value as? NSDictionary
                    var eat = values?["Eaten"] as? Int   ?? 0
                    eat = eat - self.dataFromDetail[1].cal
                    self.eaten = eat
                    self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eat])
                    self.view.layoutIfNeeded()
                }
            }
        case 3:
            btnFood[idButton-1].setImage( #imageLiteral(resourceName: "icons8-fish_food"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,3), at: idButton-1)
            dataFromDetail.remove(at: idButton)
            ref.child((Auth.auth().currentUser?.uid)!).child("Days").child((btnDate.titleLabel?.text)!).child("dinner").removeValue()
            if let data = Auth.auth().currentUser?.uid {
                ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                    let values = snapshot.value as? NSDictionary
                    var eat = values?["Eaten"] as? Int   ?? 0
                    eat = eat - self.dataFromDetail[2].cal
                    self.eaten = eat
                    self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eat])
                    self.view.layoutIfNeeded()
                }
            }
        case 4:
            btnFood[idButton-1].setImage( #imageLiteral(resourceName: "icons8-mcdonalds_french_fries"), for: .normal)
            btnFood[idButton-1].setTitle(nil, for: .normal)
            dataFromDetail.insert(("",0,4), at: idButton-1)
            dataFromDetail.remove(at: idButton)
            ref.child((Auth.auth().currentUser?.uid)!).child("Days").child((btnDate.titleLabel?.text)!).child("snack").removeValue()
            if let data = Auth.auth().currentUser?.uid {
                ref.child(data).child("Days").child((btnDate.titleLabel?.text)!).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                    let values = snapshot.value as? NSDictionary
                    var eat = values?["Eaten"] as? Int   ?? 0
                    eat = eat - self.dataFromDetail[3].cal
                    self.eaten = eat
                   
                    self.ref.child(data).child("Days").child((self.btnDate.titleLabel?.text)!).child("eaten").setValue(["Eaten":eat])
                    self.view.layoutIfNeeded()
                }
            }
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

