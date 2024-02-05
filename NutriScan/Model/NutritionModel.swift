//
//  NutritionModel.swift
//  NutriScan
//
//  Created by leonard on 2024-02-04.
//

import Foundation

struct FoodsResponse: Decodable {
    let foods: [FoodItem]
}

struct FoodItem: Decodable {
    let food_name: String
    let brand_name: String?
    let serving_qty: Int?
    let serving_unit: String?
    let serving_weight_grams: Double?
    let nf_metric_qty: Double?
    let nf_metric_uom: String?
    let nf_calories: Double?
    let nf_total_fat: Double?
    let nf_saturated_fat: Double?
    let nf_cholesterol: Double?
    let nf_sodium: Double?
    let nf_total_carbohydrate: Double?
    let nf_dietary_fiber: Double?
    let nf_sugars: Double?
    let nf_protein: Double?
    let nf_potassium: Double?
    let nf_p: Double?
}
