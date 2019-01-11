//
//  MyListTableviewCellVcTableViewCell.swift
//  HealthApp
//
//  Created by Lý Gia Huy on 1/10/19.
//  Copyright © 2019 CodeWith2w1m. All rights reserved.
//

import UIKit

class MyListTableviewCellVcTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var CaloLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
