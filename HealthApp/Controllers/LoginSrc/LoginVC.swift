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
class LoginVC: UIViewController , GIDSignInUIDelegate{

    let userDefault = UserDefaults.standard
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.style = GIDSignInButtonStyle.wide
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "UserLogined" ) {
            performSegue(withIdentifier: "InputSrc", sender: self)
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


