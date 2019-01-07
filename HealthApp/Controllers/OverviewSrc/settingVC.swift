//
//  settingVC.swift
//  HealthApp
//
//  Created by Hồ  Huy on 1/7/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit

class settingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    @IBAction func termTapped(_ sender: UIButton) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "term")
        self.navigationController?.pushViewController(destination!, animated: true)
    }
    @IBAction func aboutUsTapped(_ sender: UIButton) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "aboutUs")
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
