//
//  helper.swift
//  HealthApp
//
//  Created by Ho Huy on 12/4/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import Foundation
import FirebaseUI
extension LoginVC : FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if (error != nil){
            return
        }
        userDefault.set(true, forKey: "UserLogined")
        print(authDataResult!.user.email!)
        viewDidAppear(true)
    }
}
class UI  {
    static func addDoneButtonForTextField(controls:[UITextField]){
        
        for textFields in controls  {
            let toolBar = UIToolbar()
            toolBar.items = [
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done , target: textFields, action: #selector(UITextField.resignFirstResponder))
            ]
            toolBar.sizeToFit()
            textFields.inputAccessoryView = toolBar
            
        }
    }
}
