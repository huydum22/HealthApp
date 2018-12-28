//
//  ImageViewCell.swift
//  Wallpaper
//
//  Created by Queo on 11/20/18.
//  Copyright © 2018 Queo. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {

    var mainImageView : CustomImageView  = {
        var imageView = CustomImageView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        // imageView.image = UIImage(named: "placeholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    var foodName : UILabel = {
        var label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 250, height: 20))
        label.textColor = .white
        label.shadowColor = .white
        label.adjustsFontSizeToFitWidth = false
        label.font = label.font.withSize(20)
        return label
    }()
    var calories : UILabel = {
        var label = UILabel(frame: CGRect.init(x: 0, y: 30, width: 150, height: 20))
        label.textColor = .white
        label.shadowColor = .white
        label.adjustsFontSizeToFitWidth = false
        label.font = label.font.withSize(20)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(mainImageView)
        self.addSubview(foodName)
        self.addSubview(calories)
        mainImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

