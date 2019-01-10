//
//  AppDelegate.swift
//  HealthApp
//
//  Created by Ho Huy on 12/3/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
var DRUNK = 0
var EATEN = 0
var CALO = 0
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        retrieveFromFirebase()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        //GIDSignIn.sharedInstance().delegate = self as? GIDSignInDelegate
        return true
    }
    func retrieveFromFirebase(){
        // get the data from Firebase
        let ref = Database.database().reference()
        if let data = Auth.auth().currentUser?.uid {
            ref.child(data).child(getday()).child("water").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                
                DRUNK = values?["Water"] as? Int   ?? 0
                
            }
            ref.child(data).child(getday()).child("eaten").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                
                EATEN = values?["Eaten"] as? Int   ?? 0
                
            }
            ref.child(data).child("need").observeSingleEvent(of: .value) { (snapshot) in
                let values = snapshot.value as? NSDictionary
                CALO = values?["Calo"] as? Int   ?? 0
            }
        }
        
    }
    func getday()->String{
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        var dday = String(day)
        var mmonth = String(month)
        if day < 10{
            dday = "0"+String(day)
        }
        if month < 10 {
            mmonth = "0"+String(month)
        }
        let getADay:String = dday+"-"+mmonth+"-"+String(year)
        return getADay
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        

    }
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

