//
//  termVC.swift
//  HealthApp
//
//  Created by Hồ  Huy on 1/7/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit

class termVC: UIViewController {

    @IBOutlet weak var lblname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblname.text = "App này sinh ra với \n mục đích là giải cứu thế giới "
        // Do any additional setup after loading the view.
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
