//
//  ListExercises.swift
//  HealthApp
//
//  Created by Lý Gia Huy on 12/14/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ExerciseInfo
{
    var Category: String?
    var Name: String?
    var description: String?
    var MetValue: Double?
}

class ListExercises: UIViewController {
   
    var ref: DatabaseReference?
    var ExerciseList: [ExerciseInfo] = []
    
    @IBOutlet weak var ExerciseListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        ref = Database.database().reference().child("ExerciseList")
        
        
        
       ref?.observe(.childAdded, with: { (DataSnapshot) in
            
           var category = DataSnapshot.key
        var json = DataSnapshot.value as? [String:AnyObject]
        
        for i in json!.keys {
            var temp = ExerciseInfo()
            var json2 = json![i] as? [String:AnyObject]
            
            temp.Category = category
            temp.Name = i;
            temp.description = json2?["description"] as! String
            temp.MetValue = json2?["MetValue"] as! Double
            self.ExerciseList.append(temp)
        self.ExerciseListTableView.reloadData()
        }
        

        })
        
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
extension ListExercises: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(ExerciseList.count)")
        return ExerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseListTableViewCell", for: indexPath) as? ExerciseListTableViewCell
        
        cell?.ExerciseName.text = ExerciseList[indexPath.row].Name
       
        var UserWeightDouble = Double(weight_GHuy!)
        
        var caloburn = UserWeightDouble! * 0.0175 * ExerciseList[indexPath.row].MetValue!
        
        
        
        
        cell?.CaloriesBurnPerMin.text = String(format: "%f calories/minute", caloburn)
        
        return cell!
        
    }
    
    
}
