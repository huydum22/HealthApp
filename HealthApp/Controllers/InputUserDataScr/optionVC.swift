//
//  optionVC.swift
//  HealthApp
//
//  Created by Hồ  Huy on 12/17/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class optionVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func gainWeight(_ sender: UIButton) {	
       showPushToGenderVC()
       
    }
    @IBAction func loseWeight(_ sender: UIButton) {
        showPushToGenderVC()
    }
    @IBAction func beHealthier(_ sender: UIButton) {
       showPushToGenderVC()
    }
    func showPushToGenderVC(){
        let destination = self.storyboard!.instantiateViewController(withIdentifier: "genderSrc") as! genderVC
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
