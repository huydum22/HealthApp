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
        var haveUIDFromFirebase = 0
        ref.observe(.value) { (snapshot) in
            for item in snapshot.children{
                let uidFromFirebase = (item as AnyObject).key as? String
                if uidFromFirebase == (authDataResult?.user.uid)  {
                    haveUIDFromFirebase = 1
                }
            }
            self.userDefault.set(true, forKey: "UserLogined")
            
            if (haveUIDFromFirebase == 0 ){
                self.userDefault.set(true, forKey: "NewUser")
                self.ref.child((authDataResult?.user.uid)!).child("UID").setValue((authDataResult?.user.uid)!)
                self.ref.child((authDataResult?.user.uid)!).child("Email").setValue(authDataResult?.user.email)
                print("1")
            }
            if (haveUIDFromFirebase != 0 ) {
                self.userDefault.set(true, forKey: "OldUser")
                print("2")
            }
            self.userDefault.synchronize()
            self.viewDidAppear(true)
        }
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
