//
//  DetailFoodViewController.swift
//  HealthApp
//
//  Created by queo on 12/20/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit
import MBCircularProgressBar
class DetailFood: UIViewController {
    //
    let mainImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var caloriesBar: MBCircularProgressBarView!
    @IBOutlet weak var proBar: MBCircularProgressBarView!
    @IBOutlet weak var carbsBar: MBCircularProgressBarView!
    @IBOutlet weak var fatBar: MBCircularProgressBarView!

    @IBOutlet weak var labelPro: UILabel!
    @IBOutlet weak var labelCarbs: UILabel!
    @IBOutlet weak var labelFiber: UILabel!
    @IBOutlet weak var labelSugar: UILabel!
    @IBOutlet weak var labelFat: UILabel!
    @IBOutlet weak var labelFat1: UILabel!
    @IBOutlet weak var labelFat2: UILabel!
    @IBOutlet weak var labelOther1: UILabel!
    @IBOutlet weak var labelOther2: UILabel!
    @IBOutlet weak var labelOther3: UILabel!
    
    //
    var foodName = ""
    var yield = 1
    var calories = 299
    var proWeight = 3
    var carbsWeight = 1
    var fatWeight = 1
    var carbs1 = 1
    var carbs2 = 1
    var fat1 = 1
    var fat2 = 1
    var other1 = 1
    var other2 = 1
    var other3 = 1
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        if (mainImageView.image == nil) {
            imageFood.image = UIImage(named: "placeholder")
        }
        else {
            imageFood.image = mainImageView.image
        }
        super.viewWillAppear(animated)
    }
    func prepareInfo() {
        //
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = foodName
        //
        calories = calories / yield
        proWeight = proWeight / yield
        carbsWeight = carbsWeight / yield
        fatWeight  = fatWeight / yield
        fat1 = fat1 / yield
        fat2 = fat2 / yield
        carbs1 = carbs1 / yield
        carbs2 = carbs2 / yield
        other1 = other1 / yield
        other2 = other2 / yield
        other3 = other3 / yield
    }
    func setUp() {
        prepareInfo()
        //
        caloriesBar.value = CGFloat(calories)
        proBar.value = CGFloat((proWeight * 100) / (proWeight + carbsWeight + fatWeight))
        carbsBar.value = CGFloat((carbsWeight * 100) / (proWeight + carbsWeight + fatWeight))
        fatBar.value = CGFloat((fatWeight * 100) / (proWeight + carbsWeight + fatWeight))
        //
        labelPro.text = String(proWeight) + " g"
        labelCarbs.text = String(carbsWeight) + " g"
        labelFiber.text = String(carbs1) + " g"
        labelSugar.text = String(carbs2) + " g"
        labelFat.text = String(fatWeight) + " g"
        labelFat1.text = String(fat1) + " g"
        labelFat2.text = String(fat2) + " g"
        labelOther1.text = String(other1) + " mg"
        labelOther2.text = String(other2) + " mg"
        labelOther3.text = String(other3) + " mg"
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
