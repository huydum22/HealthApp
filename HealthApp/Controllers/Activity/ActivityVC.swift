//
//  ActivityVC.swift
//  HealthApp
//
//  Created by Ho Huy on 12/4/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
           self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationItem.title = "Exercise"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 153/255, green: 0, blue: 76/255, alpha: 0.3)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(self.isMovingFromParent)//back clicked event
        {
            navigationController?.navigationBar.barTintColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
            self.tabBarController?.tabBar.isHidden = false
        }
        
    }
  
    @IBAction func ExerciseSimpleCaloriesClicked(_ sender: Any) {
        
        let SimpleCaloriesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseSimpleCaloriesViewControllerID") as! ExerciseSimpleCaloriesVC
        
        self.addChild(SimpleCaloriesVC)
        
        self.view.addSubview(SimpleCaloriesVC.view)
        SimpleCaloriesVC.didMove(toParent: self)
        
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

