//
//  popUpViewController.swift
//  HealthApp
//
//  Created by queo on 1/5/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var caloriesText: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var mode  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         UI.addDoneButtonForTextField(controls: [titleText,caloriesText])
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        [titleText, caloriesText].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let title = titleText.text, !title.isEmpty,
            let calories = caloriesText.text, !calories.isEmpty
        else {
                self.saveButton.isEnabled = false
                return
        }
        saveButton.isEnabled = true
    }
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   
    
}

