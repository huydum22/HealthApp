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
    var mode  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         UI.addDoneButtonForTextField(controls: [titleText,caloriesText])
        registerKeyboardNotification()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deregisterKeyboardNotification()
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
        let info = notification.userInfo!
        let keyboard = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom:keyboard!.height, right: 0.0)
    }
    @objc func KeyboardWillBeHidden(notification: NSNotification)  {
        let info = notification.userInfo!
        let keyboard = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboard!.height-100, right: 0.0)
    }

}
