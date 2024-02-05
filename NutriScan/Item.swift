//
//  Item.swift
//  NutriScan
//
//  Created by leonard on 2024-01-30.
//

import Foundation
import SwiftData

@Model
class Item {
    var timestamp: Date
        var foodName: String
        var brandName: String
        var servingQty: Int?
        var servingUnit: String?
        var servingWeightGrams: Double?
        var calories: Double?
        var totalFat: Double?
        var saturatedFat: Double?
        var cholesterol: Double?
        var sodium: Double?
        var totalCarbohydrate: Double?
        var dietaryFiber: Double?
        var sugars: Double?
        var protein: Double?
        var potassium: Double?
        var phosphorus: Double? // Representing nfP
    
    init(timestamp: Date, name: String, brandName: String, servingQty: Int? = nil, servingUnit: String? = nil, servingWeightGrams: Double? = nil, calories: Double? = nil, totalFat: Double? = nil, saturatedFat: Double? = nil, cholesterol: Double? = nil, sodium: Double? = nil, totalCarbohydrate: Double? = nil, dietaryFiber: Double? = nil, sugars: Double? = nil, protein: Double? = nil, potassium: Double? = nil, phosphorus: Double? = nil) {
        self.timestamp = timestamp
        self.foodName = name
        self.brandName = brandName
        self.servingQty = servingQty
        self.servingUnit = servingUnit
        self.servingWeightGrams = servingWeightGrams
        self.calories = calories
        self.totalFat = totalFat
        self.saturatedFat = saturatedFat
        self.cholesterol = cholesterol
        self.sodium = sodium
        self.totalCarbohydrate = totalCarbohydrate
        self.dietaryFiber = dietaryFiber
        self.sugars = sugars
        self.protein = protein
        self.potassium = potassium
        self.phosphorus = phosphorus
    }
    
    convenience init(from foodItem: FoodItem, timestamp: Date = Date()) {
        self.init(
                    timestamp: timestamp,
                    name: foodItem.foodName,
                    brandName: foodItem.brandName ?? "",
                    servingQty: foodItem.servingQty,
                    servingUnit: foodItem.servingUnit,
                    servingWeightGrams: foodItem.servingWeightGrams,
                    calories: foodItem.nfCalories,
                    totalFat: foodItem.nfTotalFat,
                    saturatedFat: foodItem.nfSaturatedFat,
                    cholesterol: foodItem.nfCholesterol,
                    sodium: foodItem.nfSodium,
                    totalCarbohydrate: foodItem.nfTotalCarbohydrate,
                    dietaryFiber: foodItem.nfDietaryFiber,
                    sugars: foodItem.nfSugars,
                    protein: foodItem.nfProtein,
                    potassium: foodItem.nfPotassium,
                    phosphorus: foodItem.nfP
        )
    }
}
