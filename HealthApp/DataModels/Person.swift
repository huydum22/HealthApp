//
//  File.swift
//  HealthApp
//
//  Created by Ho Huy on 12/4/18.
//  Copyright © 2018 CodeWith2w1m. All rights reserved.
//

import Foundation
class Person{
    var Name :String
    var Sex : String
    var UID :String
    var Age: Int
    var Height : Int
    var Weight : Int
    var ActivityLevel : Int
    init(name : String,sex :String,uid :String, age :Int, height : Int , weight : Int , activitylevel : Int) {
        self.Name = name
        self.Sex = sex
        self.UID  = uid
        self.Age = age
        self.Height = height
        self.Weight = weight
        self.ActivityLevel = activitylevel
    }
    
    
}
