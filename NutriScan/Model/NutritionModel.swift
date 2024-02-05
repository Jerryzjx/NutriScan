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
    let foodName: String
    let brandName: String?
    let servingQty: Int?
    let servingUnit: String?
    let servingWeightGrams: Double?
    let nfMetricQty: Double?
    let nfMetricUom: String?
    let nfCalories: Double?
    let nfTotalFat: Double?
    let nfSaturatedFat: Double?
    let nfCholesterol: Double?
    let nfSodium: Double?
    let nfTotalCarbohydrate: Double?
    let nfDietaryFiber: Double?
    let nfSugars: Double?
    let nfProtein: Double?
    let nfPotassium: Double?
    let nfP: Double?

    enum CodingKeys: String, CodingKey {
        case foodName = "food_name"
        case brandName = "brand_name"
        case servingQty = "serving_qty"
        case servingUnit = "serving_unit"
        case servingWeightGrams = "serving_weight_grams"
        case nfMetricQty = "nf_metric_qty"
        case nfMetricUom = "nf_metric_uom"
        case nfCalories = "nf_calories"
        case nfTotalFat = "nf_total_fat"
        case nfSaturatedFat = "nf_saturated_fat"
        case nfCholesterol = "nf_cholesterol"
        case nfSodium = "nf_sodium"
        case nfTotalCarbohydrate = "nf_total_carbohydrate"
        case nfDietaryFiber = "nf_dietary_fiber"
        case nfSugars = "nf_sugars"
        case nfProtein = "nf_protein"
        case nfPotassium = "nf_potassium"
        case nfP = "nf_p"
    }
}
