//
//  ExerciseRecentVC.swift
//  HealthApp
//
//  Created by Lý Gia Huy on 12/31/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
var ExerciseRecentList:[ExerciseInfo] = []
class ExerciseRecentVC: UIViewController {
    
    @IBOutlet weak var TableView: UITableView!
    var UserInfoRef: DatabaseReference?
    var UserWeight: Double = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let UserID = Auth.auth().currentUser?.uid
        
        UserInfoRef = Database.database().reference().child(UserID!).child("info")
        
        UserInfoRef?.observe(.childAdded, with: { (DataSnapshot) in
            
            if DataSnapshot.key == "Weight"
            {
                self.UserWeight = (DataSnapshot.value as? Double)!
                self.TableView.reloadData()
            }
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecentVCToExerciseInfoVC"
        {
            let Exercise = sender as! ExerciseInfo
            let DestExerciseInfoVC = segue.destination as! ExerciseInfoVC
            DestExerciseInfoVC.Exercise = Exercise
            DestExerciseInfoVC.UserWeight = self.UserWeight
            
        }
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

extension ExerciseRecentVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ExerciseRecentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseRecentTableViewCell") as! ExerciseRecentTableViewCell
        
        cell.NameLabel.text = ExerciseRecentList[indexPath.row].Name
        let caloburn = UserWeight * 0.0175 * ExerciseRecentList[indexPath.row].MetValue!
        cell.kcaloBurnedLabel.text = String(format: "%d kcalo/minute", Int(caloburn))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RecentVCToExerciseInfoVC", sender: ExerciseRecentList[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
