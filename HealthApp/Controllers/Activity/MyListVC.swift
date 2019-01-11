//
//  MyListVC.swift
//  HealthApp
//
//  Created by Lý Gia Huy on 1/10/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth

class SelectedExercise
{
    var name: String?
    var calo: String?
    var ID: String?

}

class MyListVC: UIViewController {
    
    @IBOutlet weak var ListExerciseTableView: UITableView!
    var ExerciseList: [SelectedExercise] = []
    var ref: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
        let UserID = Auth.auth().currentUser?.uid
        let Dateformatter = DateFormatter()
        
        Dateformatter.dateFormat = "dd-MM-yyyy"
        let strTodayDate = Dateformatter.string(from: Date())
        
         ref = Database.database().reference().child(UserID!).child(strTodayDate).child("ExerciseDailyData")
        
        ref!.child("ExerciseList").observe(.value) { (Snapshot) in
            
            if let result = Snapshot.children.allObjects as? [DataSnapshot]
            {
                for DataSnapshot in result
                {
                    let exercise: SelectedExercise = SelectedExercise()
                    exercise.ID = DataSnapshot.key
                    print(DataSnapshot.value)
                    var json = DataSnapshot.value as! [String:AnyObject]
                    exercise.name = json["Name"] as! String
                    var temp = json["Calories"] as! Int
                    exercise.calo =
                       String(format: "%d kcalo/Minutes", temp)
                    self.ExerciseList.append(exercise)
                   
                }
            
            }
             self.ListExerciseTableView.reloadData()
        }
        
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
extension MyListVC: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyListTableViewCell", for: indexPath) as? MyListTableviewCellVcTableViewCell
        cell?.CaloLabel.text = ExerciseList[indexPath.row].calo
        cell?.NameLabel.text = ExerciseList[indexPath.row].name
        return cell!
    }
    
    
    
}
