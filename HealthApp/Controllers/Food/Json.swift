//
//  File.swift
//  Wallpaper
//
//  Created by Queo on 11/20/18.
//  Copyright © 2018 Queo. All rights reserved.
//

import UIKit

struct JsonData : Decodable {
    let hits : [hit]?
}
struct hit : Decodable {
    let recipe : foodData?
}
struct foodData :Decodable {
    let label : String?
    let image : String?
    let yield : Int?
    let calories : Float?
    let totalNutrients : Nutrition?
}
struct Nutrition : Decodable {
    let FAT : component? // FAT
    let FASAT : component? // Saturated
    let FAMS : component? // Unsaturated
    let CHOCDF : component? // CARBS
    let FIBTG : component? // Fiber
    let SUGAR : component? // Sugars
    let PROCNT : component? // PROTEIN
    let CHOLE : component? // Cholesterol
    let NA : component? // Sodium
    let K : component? // Potassium
}
struct component : Decodable {
    let label : String?
    let quantity: Float?
}
var urlFoodArr = [foodData]()
