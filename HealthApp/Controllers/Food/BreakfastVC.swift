//
//  FoodsVC.swift
//  HealthApp
//
//  Created by Ho Huy on 12/4/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class BreakfastVC: UIViewController {

  
    var mode = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode  = .always
        switch mode {
        case 1:
            self.navigationItem.title = "Breakfast"
        case 2:
            self.navigationItem.title = "Lunch"
        case 3:
            self.navigationItem.title = "Dinner"
        case 4:
            self.navigationItem.title = "Snack"
        default:
            self.navigationItem.title = "Recipes"
        }
    }

    @IBAction func createFood(_ sender: Any) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "popUpID")  as!popUpViewController
        destination.mode = self.mode
        self.present(destination, animated: true , completion: nil)
    }
    @IBAction func showListFood(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "ListFoodID") as! ListFood
        destination.defaultSearchText = self.navigationItem.title ?? "food"
        destination.mode = self.mode
        self.navigationController?.pushViewController(destination, animated: true)
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
