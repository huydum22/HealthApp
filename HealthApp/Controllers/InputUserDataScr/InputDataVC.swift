//
//  InputDataVC.swift
//  HealthApp
//
//  Created by Ho Huy on 12/4/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit
import Firebase

class InputDataVC: UIViewController {
    
    //MARk::elements
    var gender : String = ""
    var activitylevel:Int = 1
    var ref: DatabaseReference!
    let userDefault = UserDefaults.standard
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtGoalWeight: UITextField!
    @IBOutlet var btnActivity: [UIButton]!
    @IBOutlet var btnTime: [UIButton]!
    @IBOutlet weak var btnPickerTime: UIButton!
    @IBOutlet weak var btnPicker: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    
    //MARk::dashboards
    override func viewDidLoad() {
        super.viewDidLoad()
        UI.addDoneButtonForTextField(controls: [txtName,txtHeight,txtGoalWeight,txtAge,txtWeight])
        registerKeyboardNotification()
        ref = Database.database().reference()
        self.ref.observe(.value) { (snapshot) in
            for item in snapshot.children{
                let uidFromFirebase = (item as! DataSnapshot).key
                if uidFromFirebase == (Auth.auth().currentUser?.uid)  {
                    self.ref.child(uidFromFirebase).child("info").observeSingleEvent(of: .value) { (snapshot2) in
                        let values = snapshot2.value as? NSDictionary
                        self.txtName.text = values?["Name"] as? String ?? ""
                        let age = values?["Age"] as? Int ?? 0
                        self.txtAge.text = String(age)
                        let height = values?["Height"] as? Float ?? 0
                        self.txtHeight.text = String(height)
                        let weight = values?["Weight"] as? Float ?? 0
                        self.txtWeight.text = String(weight)
                        let goalweight = values?["Goal weight"] as? Float ?? 0
                        self.txtGoalWeight.text = String(goalweight)
                }
            }
        }
    }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterKeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "UserLogined" ) == false {
            let destination = storyboard?.instantiateViewController(withIdentifier: "LoginSrc")
            present(destination!, animated: true, completion: nil)
        }
    }
    
    
    
    
    //MARk::events
    
    
    @IBAction func tappedGoal(_ sender: UIButton) {
        btnPickerTime.setTitle(sender.titleLabel?.text, for: .normal)
        btnTime.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func tappedActivityLevel(_ sender: UIButton) {
        btnPicker.setTitle(sender.titleLabel?.text, for: .normal)
        btnActivity.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        switch btnPicker.titleLabel?.text {
        case "Low ( 1 times/week)":
            activitylevel = 1
        case "Medium ( 1-3 times/week)":
            activitylevel = 2
        case "High (3-5 times/week)":
            activitylevel = 3
        case "Very high (6-7 times/week)":
            activitylevel = 4
        case "absolute ( >7 times/week )":
            activitylevel = 5
        default:
            activitylevel = 1
        }
    }
    
    
    func GetWater(_ weight: Float) -> Int {
        var minutes: Int
        switch activitylevel {
        case 1:
            minutes = 45
        case 2:
            minutes = 45 * 2
        case 3:
            minutes = 45 * 4
        case 4:
            minutes = 45 * 6
        case 5:
            minutes = 45 * 7
        default:
            minutes = 45
        }
        return Int(weight * 30) + minutes * 12
    }
    func GetCal(_ sex: String,_ weight: Float,_ height: Float,_ age: Int) -> Int
    {
        var BMR : Float
        var tmp : Float
        if (sex == "Male") {
            
            BMR = ( weight * 13.397 ) + (4.799 * height) - ( Float(age) * 5.677 ) + 88.362
        }
        else {
            BMR =  (weight * 9.247 ) + ( height * 3.098 )   - (Float(age) * 4.330 )  + 447.593
        }
        switch activitylevel {
        case 1:
            tmp = 1.2
        case 2:
            tmp = 1.375
        case 3:
            tmp = 1.55
        case 4:
            tmp = 1.725
        case 5:
            tmp = 1.9
        default:
            tmp = 1.2
        }
        return Int(BMR * tmp)
    }
    @IBAction func CompleteData(_ sender: UIButton) {
        if let name = txtName.text ,   let age = Int(txtAge.text!) , let height = Float(txtHeight.text!), let weight = Float(txtWeight.text!)  ,  let goalweight = Float(txtGoalWeight.text!){
            ref.child((Auth.auth().currentUser?.uid)!).child("info").setValue(["Name":name,"Sex":gender,"Age" : age,"Height":height ,"Weight":weight,"Goal weight": goalweight])
            ref.child((Auth.auth().currentUser?.uid)!).child("need").setValue(["Water(ml)":GetWater(weight),"Calo":GetCal(gender, weight, height,age) ])
            let destination = storyboard?.instantiateViewController(withIdentifier: "OverviewSrc")
            present(destination!, animated: true, completion: nil)
        }
        else {

            let alert  = UIAlertController(title: "NOTIFICATION", message: "please input your infomation !!!", preferredStyle: .alert)
            let okAction  = UIAlertAction(title: "Ok", style: .default, handler: nil)
             alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func registerKeyboardNotification()  {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func deregisterKeyboardNotification()  {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func KeyboardWasShown(notification: NSNotification)  {
        scrollView.isScrollEnabled = true
        let info = notification.userInfo!
        let keyboard = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom:keyboard!.height, right: 0.0)
        self.scrollView.contentInset =  contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func KeyboardWillBeHidden(notification: NSNotification)  {
        let info = notification.userInfo!
        let keyboard = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboard!.height-100, right: 0.0)
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
}
