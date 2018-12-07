//
//  LoginViewController.swift
//  HealthApp
//
//  Created by Ho Huy on 12/3/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseUI
class LoginVC: UIViewController , GIDSignInUIDelegate, GIDSignInDelegate {

    var ref: DatabaseReference!
    let userDefault = UserDefaults.standard
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.style = GIDSignInButtonStyle.wide
        ref = Database.database().reference()
    }
    
   
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.userDefault.set(true, forKey: "UserLogined")
            self.userDefault.synchronize()
            var haveUIDFromFirebase = 0
            self.ref.observe(.value) { (snapshot) in
                for item in snapshot.children{
                    let uidFromFirebase = (item as! DataSnapshot).key
                    if uidFromFirebase == (authResult?.user.uid)  {
                        haveUIDFromFirebase = 1
                    }
                }
                if (haveUIDFromFirebase == 0 ){
                    self.userDefault.set(true, forKey: "NewUser")
                    self.ref.child((authResult?.user.uid)!).child("UID").setValue((authResult?.user.uid)!)
                    self.ref.child((authResult?.user.uid)!).child("Email").setValue((authResult?.user.email)!)
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
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "UserLogined" ) {
            if userDefault.bool(forKey:"NewUser" ) {
                self.performSegue(withIdentifier: "InputSrc", sender: self)
            }
            if userDefault.bool(forKey:"OldUser" ) {
                self.performSegue(withIdentifier: "OverviewSrc", sender: self)
            }
        }
    }


    @IBAction func LogInTapped(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        guard authUI != nil else {
            return
        }
        authUI?.delegate = self
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
    
    @IBAction func LogInTappedGG(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
}


