//
//  genderVC.swift
//  HealthApp
//
//  Created by Hồ  Huy on 12/17/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class genderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func touchMale(_ sender: UIButton) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "InputSrc") as! InputDataVC
       destination.gender = "Male"
        self.show(destination, sender: self)
        //self.navigationController?.pushViewController(destination, animated: true)
    }
    @IBAction func touchFemale(_ sender: Any) {
        let destination = storyboard?.instantiateViewController(withIdentifier: "InputSrc") as! InputDataVC
        destination.gender = "Female"
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
