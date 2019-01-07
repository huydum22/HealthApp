//
//  ExerciseSimpleCaloriesVC.swift
//  HealthApp
//
//  Created by Lý Gia Huy on 1/1/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ExerciseSimpleCaloriesVC: UIViewController {

    @IBOutlet weak var TiltleTextField: UITextField!
    @IBOutlet weak var CaloriesTextField: UITextField!
    var strTodayDate:String?
    var UserID: String?
    var TotalCaloriesBurned = 0
    var ref: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        AddDoneButtonForNumpad()
        TiltleTextField.underlined()
        CaloriesTextField.underlined()
        
        
        
        
        
        
        
        let Dateformatter = DateFormatter()
        
        Dateformatter.dateFormat = "dd-MM-yyyy"
        strTodayDate = Dateformatter.string(from: Date())
        
        UserID = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child(UserID!).child("ExerciseDailyData").child(strTodayDate!)
        
        ref!.observe(.value) { (DataSnapshot) in
            if (DataSnapshot.hasChild("TotalCaloriesBurned"))
            {
                let json = DataSnapshot.value as! [String:AnyObject]
                self.TotalCaloriesBurned = json["TotalCaloriesBurned"] as! Int
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CancelButtonClicked(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func SaveButtonClicked(_ sender: Any) {

        if (TiltleTextField.text?.isEmpty)!
        {
            
            TiltleTextField.endEditing(true)
            CaloriesTextField.endEditing(true)
            TiltleTextField.layer.shadowColor = UIColor.red.cgColor
            return
            
        }
        if((CaloriesTextField.text?.isEmpty)!)
        {
            
            TiltleTextField.endEditing(true)
            CaloriesTextField.endEditing(true)
            CaloriesTextField.layer.shadowColor = UIColor.red.cgColor
            return
        }
        TotalCaloriesBurned = TotalCaloriesBurned + Int(CaloriesTextField.text!)!
        WrireDataIntoFirebase()
            self.view.removeFromSuperview()
       
    }
    func AddDoneButtonForNumpad(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.DoneAction))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,donebutton], animated: false)
        
        CaloriesTextField.inputAccessoryView = toolbar
    }
    @objc func DoneAction(){
        CaloriesTextField.endEditing(true)
    
    }
    
    func WrireDataIntoFirebase() {
        
        
        let ExerciseListDailyDataRef = ref!.child("ExerciseList").childByAutoId()
        ExerciseListDailyDataRef.child("Name").setValue(TiltleTextField.text)
        ExerciseListDailyDataRef.child("Minutes").setValue(0)
        ExerciseListDailyDataRef.child("Calories").setValue(CaloriesTextField.text)
        
        
        let ExerciseTotalCaloriesBurnedRef = ref!.child("TotalCaloriesBurned")
        ExerciseTotalCaloriesBurnedRef.setValue(TotalCaloriesBurned)
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
extension ExerciseSimpleCaloriesVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.shadowColor = UIColor.green.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        textField.layer.shadowColor = UIColor.black.cgColor
    }

}
