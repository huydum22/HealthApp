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
    var ref: DatabaseReference!
    let userDefault = UserDefaults.standard
    @IBOutlet weak var genderPicked: UIButton!
    @IBOutlet var Genders: [UIButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var AcitivityBtn: [UILabel]!
    @IBOutlet weak var txtWeek: UITextField!
    @IBOutlet weak var txtday: UITextField!
    @IBOutlet weak var btnActivity: UIButton!
    @IBOutlet weak var btndone: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    @IBOutlet var viewController: UIView!
    
    //MARk::dashboards
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotification()
        UI.addDoneButtonForTextField(controls: [txtWeek,txtday,txtName,txtAge,txtHeight,txtWeight])
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "UserLogined" ) == false {
            performSegue(withIdentifier: "LoginSrc", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterKeyboardNotification()
    }
    
    
    
    //MARk::events
    @IBAction func InputActivityLevel(_ sender: UIButton) {
        AcitivityBtn.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.txtWeek.isHidden = !self.txtWeek.isHidden
            self.txtday.isHidden = !self.txtday.isHidden
            self.btndone.isHidden = !self.btndone.isHidden
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func DoneBtnActivity(_ sender: UIButton) {
        AcitivityBtn.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.txtWeek.isHidden = !self.txtWeek.isHidden
            self.txtday.isHidden = !self.txtday.isHidden
            self.btndone.isHidden = !self.btndone.isHidden
            self.view.layoutIfNeeded()
        })
        if txtday.text != "" && txtWeek.text != ""{
            btnActivity.titleLabel?.text = "Done ✅"
        }
    }
    
    @IBAction func SelectGender(_ sender: UIButton) {
        genderPicked.titleLabel?.text = genderPicked.titleLabel?.text
        Genders.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func GenderTapped(_ sender: UIButton) {
        genderPicked.titleLabel?.text = sender.titleLabel?.text
        self.view.layoutIfNeeded()
        Genders.forEach { (button) in
            UIView.animate(withDuration: 0.2, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    func GetWater(_ weight: Int,_ minutes: Int) -> Int {
        return weight * 30 + minutes * 12
    }
    func GetCal(_ sex: String,_ weight: Float,_ height: Float,_ age: Float,_ activityLevel: Int) -> Int
    {
        var BMR : Float
        var tmp : Float
        if (sex == "Male") {
            BMR = 13.397 * weight + 4.799 * height - 5.677 * age + 88.362
            
        }
        else {
            BMR =  9.247*weight + 3.098*height  - 4.330*age + 447.593
        }
        switch activityLevel {
        case 1:
            tmp = 1.2
        case 2:
            tmp = 1.375
        case 3:
            tmp = 1.55
        case 4:
            tmp = 1.725
        default:
            tmp = 1.9
        }
        return Int(BMR * tmp)
    }
    @IBAction func CompleteData(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "OverviewSrc") as! UINavigationController
        //let seque = destination.viewControllers.first as! OverviewVC
        ref.child((Auth.auth().currentUser?.uid)!).child("info").setValue(["Name":txtName.text!,"Sex":(genderPicked.titleLabel?.text!)!,"Age" :Int(txtAge.text!)!,"Height":Int(txtHeight.text!)!,"Weight":Int(txtWeight.text!)!,"calo": Int(txtday.text!)! * Int(txtWeek.text!)!])
        ref.child((Auth.auth().currentUser?.uid)!).child("need").setValue(["Water(ml)":GetWater(Int(txtWeight.text!)!, Int(txtday.text!)!),"Calo":GetCal((genderPicked.titleLabel?.text!)!, Float(txtWeight.text!)!, Float(txtHeight.text!)!,Float(txtAge.text!)! , 3)])
        //seque.dataUser = Person(name: txtName.text!, sex: (genderPicked.titleLabel?.text!)!, uid: "1", age: Int(txtAge.text!)!, height: Int(txtHeight.text!)!, weight: Int(txtWeight.text!)!, activitylevel: Int(txtday.text!)! * Int(txtWeek.text!)!)
        
        self.show(destination, sender: self)
    }

    
    // MARK: srcollView
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
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboard!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
    
    
}


