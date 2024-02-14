//
//  HealthKitManager.swift
//  NutriScan
//
//  Created by leonard on 2024-02-09.
//

import Foundation
import HealthKit
import WidgetKit

class HealthKitManager: ObservableObject {
    var healthStore: HKHealthStore?

        init() {
            if HKHealthStore.isHealthDataAvailable() {
                healthStore = HKHealthStore()
            } else {
                print("Health data is not available")
            }
        }
    
  
    func requestAuthorization() {
        guard let healthStore = healthStore else { return }

        let writeDataTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
            HKObjectType.quantityType(forIdentifier: .dietaryProtein)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFatTotal)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated)!,
            HKObjectType.quantityType(forIdentifier: .dietaryCholesterol)!,
            HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates)!,
            HKObjectType.quantityType(forIdentifier: .dietaryFiber)!,
            HKObjectType.quantityType(forIdentifier: .dietarySugar)!,
            HKObjectType.quantityType(forIdentifier: .dietarySodium)!
        ]

        let readDataTypes: Set = writeDataTypes

        healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes) { success, error in
            if !success {
                
            }
        }
    }
    
    func saveNutritionalDataFromFoodItem(for foodItem: FoodItem, date: Date, completion: @escaping (Bool, Error?) -> Void) {
        let now = date
        var samples: [HKQuantitySample] = []

        
        if let calories = foodItem.nfCalories {
            if let energyType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) {
                let quantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
                let sample = HKQuantitySample(type: energyType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        if let protein = foodItem.nfProtein {
            if let proteinType = HKQuantityType.quantityType(forIdentifier: .dietaryProtein) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: protein)
                let sample = HKQuantitySample(type: proteinType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }
        
        
        if let fatTotal = foodItem.nfTotalFat {
            if let fatTotalType = HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: fatTotal)
                let sample = HKQuantitySample(type: fatTotalType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let fatSaturated = foodItem.nfSaturatedFat {
            if let fatSaturatedType = HKQuantityType.quantityType(forIdentifier: .dietaryFatSaturated) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: fatSaturated)
                let sample = HKQuantitySample(type: fatSaturatedType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let cholesterol = foodItem.nfCholesterol {
            if let cholesterolType = HKQuantityType.quantityType(forIdentifier: .dietaryCholesterol) {
                let quantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: cholesterol)
                let sample = HKQuantitySample(type: cholesterolType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let carbohydrates = foodItem.nfTotalCarbohydrate {
            if let carbohydratesType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: carbohydrates)
                let sample = HKQuantitySample(type: carbohydratesType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let fiber = foodItem.nfDietaryFiber {
            if let fiberType = HKQuantityType.quantityType(forIdentifier: .dietaryFiber) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: fiber)
                let sample = HKQuantitySample(type: fiberType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let sugar = foodItem.nfSugars {
            if let sugarType = HKQuantityType.quantityType(forIdentifier: .dietarySugar) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: sugar)
                let sample = HKQuantitySample(type: sugarType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let sodium = foodItem.nfSodium {
            if let sodiumType = HKQuantityType.quantityType(forIdentifier: .dietarySodium) {
                let quantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: sodium)
                let sample = HKQuantitySample(type: sodiumType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        HKHealthStore().save(samples) { success, error in
            completion(success, error)
        }
    }
    
    func saveNutritionalDataFromItem(for foodItem: Item, completion: @escaping (Bool, Error?) -> Void) {
        let now = foodItem.timestamp
        var samples: [HKQuantitySample] = []

        if let calories = foodItem.nfCalories {
            if let energyType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed) {
                let quantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
                let sample = HKQuantitySample(type: energyType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }
       
        if let protein = foodItem.nfProtein {
            if let proteinType = HKQuantityType.quantityType(forIdentifier: .dietaryProtein) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: protein)
                let sample = HKQuantitySample(type: proteinType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }
    
        if let fatTotal = foodItem.nfTotalFat {
            if let fatTotalType = HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: fatTotal)
                let sample = HKQuantitySample(type: fatTotalType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let fatSaturated = foodItem.nfSaturatedFat {
            if let fatSaturatedType = HKQuantityType.quantityType(forIdentifier: .dietaryFatSaturated) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: fatSaturated)
                let sample = HKQuantitySample(type: fatSaturatedType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let cholesterol = foodItem.nfCholesterol {
            if let cholesterolType = HKQuantityType.quantityType(forIdentifier: .dietaryCholesterol) {
                let quantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: cholesterol)
                let sample = HKQuantitySample(type: cholesterolType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let carbohydrates = foodItem.nfTotalCarbohydrate {
            if let carbohydratesType = HKQuantityType.quantityType(forIdentifier: .dietaryCarbohydrates) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: carbohydrates)
                let sample = HKQuantitySample(type: carbohydratesType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let fiber = foodItem.nfDietaryFiber {
            if let fiberType = HKQuantityType.quantityType(forIdentifier: .dietaryFiber) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: fiber)
                let sample = HKQuantitySample(type: fiberType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let sugar = foodItem.nfSugars {
            if let sugarType = HKQuantityType.quantityType(forIdentifier: .dietarySugar) {
                let quantity = HKQuantity(unit: HKUnit.gram(), doubleValue: sugar)
                let sample = HKQuantitySample(type: sugarType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }

        
        if let sodium = foodItem.nfSodium {
            if let sodiumType = HKQuantityType.quantityType(forIdentifier: .dietarySodium) {
                let quantity = HKQuantity(unit: HKUnit.gramUnit(with: .milli), doubleValue: sodium)
                let sample = HKQuantitySample(type: sodiumType, quantity: quantity, start: now, end: now)
                samples.append(sample)
            }
        }


        HKHealthStore().save(samples) { success, error in
            completion(success, error)
        }
    }

  
}
