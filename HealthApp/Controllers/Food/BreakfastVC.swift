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
        navigationItem.title = "Breakfast"
        
    }

    @IBAction func createFood(_ sender: Any) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "popUpID")  as!popUpViewController
        self.present(destination, animated: true , completion: nil)
    }
    @IBAction func showListFood(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "ListFoodID")  
        self.navigationController?.pushViewController(destination!, animated: true)
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
