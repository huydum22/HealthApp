//
//  FoodsVC.swift
//  HealthApp
//
//  Created by Ho Huy on 12/4/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class BreakfastVC: UIViewController {

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNaBar()
        // Do any additional setup after loading the view.
    }
    func setUpNaBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Breakfast"
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
