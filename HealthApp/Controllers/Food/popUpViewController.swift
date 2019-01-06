//
//  popUpViewController.swift
//  HealthApp
//
//  Created by queo on 1/5/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var caloriesText: UITextField!
    var mode  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         UI.addDoneButtonForTextField(controls: [titleText,caloriesText])
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
