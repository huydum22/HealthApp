//
//  ActivityVC.swift
//  HealthApp
//
//  Created by Ho Huy on 12/4/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class ActivityVC: UIViewController {
    var getday = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
           self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationItem.title = "Exercise"
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @IBAction func showHealthKitVC(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "HealthKitvc") as! ViewController
        destination.getday = self.getday
        self.navigationController?.pushViewController(destination, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(self.isMovingFromParent)//back clicked event
        {
           
            self.tabBarController?.tabBar.isHidden = false
        }
        
    }
  
    @IBAction func ExerciseSimpleCaloriesClicked(_ sender: Any) {
        
        let SimpleCaloriesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExerciseSimpleCaloriesViewControllerID") as! ExerciseSimpleCaloriesVC
        
        self.addChild(SimpleCaloriesVC)
        SimpleCaloriesVC.view.frame = self.view.frame
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

