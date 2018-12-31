//
//  ExerciseInfoVC.swift
//  HealthApp
//
//  Created by Lý Gia Huy on 12/30/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class ExerciseInfoVC: UIViewController {
    var Exercise:ExerciseInfo?
    var UserWeight:Double? = nil
    var KcaloBurned:Double?
    
    var TimeExercise: Int = 30
    
    
    
    @IBOutlet weak var MinutesTestField: UITextField!
    
    @IBOutlet weak var TimeTestField: UITextField!

    @IBOutlet weak var KcaloLabel: UILabel!
    
    @IBOutlet weak var Description: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimeTestField.underlined()
        MinutesTestField.underlined()
        
        AddDoneButtonForNumpad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Exercise?.Name!

      
        KcaloBurned = Double(TimeExercise)*0.0175*(Exercise?.MetValue)!*UserWeight!
        KcaloLabel.text = String(Int(KcaloBurned!))
        Description.text = Exercise!.description
        // Do any additional setup after loading the view.
    }
    
    @IBAction func TimeEditingChangeAction(_ sender: Any) {
        
        if(TimeTestField.text!.isEmpty)
        {
            TimeExercise = 0
        
        }
        else
        {
            TimeExercise = Int(TimeTestField.text!)!
        }
        
        
        KcaloBurned = Double(TimeExercise)*0.0175*(Exercise?.MetValue)!*UserWeight!
        KcaloLabel.text = String(Int(KcaloBurned!))
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    func AddDoneButtonForNumpad(){
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        var donebutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.DoneAction))
        
        var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace,donebutton], animated: false)
        
        TimeTestField.inputAccessoryView = toolbar
    }
    
    @objc func DoneAction()
    {
        TimeTestField.endEditing(true)
        }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TimeTestField.endEditing(true)
        
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
extension UITextField{
    
    func underlined(){
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
