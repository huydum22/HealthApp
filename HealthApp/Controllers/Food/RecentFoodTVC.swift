//
//  RecentFoodTVC.swift
//  HealthApp
//
//  Created by Hồ  Huy on 1/16/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit
import  Firebase

class RecentFoodTVC: UITableViewController {
    
    var ref: DatabaseReference!
    var myListFood = [String]()
    var mode = 0
    var getday = ""
    @IBOutlet var recentFood: UITableView!
    override func viewDidLoad() {
        LoadCalls()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = getday
        navigationItem.hidesSearchBarWhenScrolling = false
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        DispatchQueue.main.async {
            self.recentFood.reloadData()
            
        }
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myListFood.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func LoadCalls() {
        if mode == 1 {
        ref = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Days").child(getday).child("breakfast")
        
        ref!.child("breakfasts").observe(.value) { (Snapshot) in
            
            if let result = Snapshot.children.allObjects as? [DataSnapshot]
            {
                for DataSnapshot in result
                {
                    var values = DataSnapshot.value as! [String:AnyObject]
                    self.myListFood.append(values["Name"] as! String)
                    }
                }
                self.recentFood.reloadData()
            }
        }
        if mode == 2{
            ref = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Days").child(getday).child("lunch")
            
            ref!.child("lunchs").observe(.value) { (Snapshot) in
                
                if let result = Snapshot.children.allObjects as? [DataSnapshot]
                {
                    for DataSnapshot in result
                    {
                        var values = DataSnapshot.value as! [String:AnyObject]
                        self.myListFood.append(values["Name"] as! String)
                    }
                }
                self.recentFood.reloadData()
            }
        }
        if mode == 3{
            ref = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Days").child(getday).child("dinner")
            
            ref!.child("dinners").observe(.value) { (Snapshot) in
                
                if let result = Snapshot.children.allObjects as? [DataSnapshot]
                {
                    for DataSnapshot in result
                    {
                        var values = DataSnapshot.value as! [String:AnyObject]
                        self.myListFood.append(values["Name"] as! String)
                    }
                }
                self.recentFood.reloadData()
            }
        }
        if mode == 4 {
            ref = Database.database().reference().child((Auth.auth().currentUser?.uid)!).child("Days").child(getday).child("snack")
            
            ref!.child("snacks").observe(.value) { (Snapshot) in
                
                if let result = Snapshot.children.allObjects as? [DataSnapshot]
                {
                    for DataSnapshot in result
                    {
                        var values = DataSnapshot.value as! [String:AnyObject]
                        self.myListFood.append(values["Name"] as! String)
                    }
                }
                self.recentFood.reloadData()
            }
        }

    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idcell", for: indexPath) as! RecentFoodTVCell

        // Configure the cell...
        cell.lblName.text = myListFood[indexPath.row]
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
