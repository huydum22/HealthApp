//
//  ExerciseListTableViewCell.swift
//  HealthApp
//
//  Created by Lý Gia Huy on 12/16/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import UIKit

class ExerciseListTableViewCell: UITableViewCell {
  
    @IBOutlet weak var CaloriesBurnPerMin: UILabel!
    @IBOutlet weak var ExerciseName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
