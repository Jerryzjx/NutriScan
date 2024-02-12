//
//  NutritionViewModel.swift
//  NutriScan
//
//  Created by leonard on 2024-02-12.
//

import Foundation
import SwiftData

enum NutrientType {
    case calories
    case protein
    case carbohydrates
    case sugar
    case fiber
    case fats
    case saturatedFats
}

class NutritionViewModel: ObservableObject {
    
    func nutrientIntakeByHour(nutrientType: NutrientType, items: [Item], forDay day: Date) -> [(hour: Int, totalIntake: Double)] {
        let calendar = Calendar.current
        var groupedByHour = [Int: [Item]]()

        // Filter items to include only those that belong to the specified day
        let dayItems = items.filter {
            calendar.isDate($0.timestamp, inSameDayAs: day)
        }

        for item in dayItems {
            let hour = calendar.component(.hour, from: item.timestamp)
            groupedByHour[hour, default: []].append(item)
        }

        var hourlyIntake = [(hour: Int, totalIntake: Double)]()

        for (hour, items) in groupedByHour {
            let totalIntake: Double = items.reduce(0) { total, item in
                total + (valueForNutrientType(item: item, nutrientType: nutrientType) ?? 0)
            }
            hourlyIntake.append((hour, totalIntake))
        }

        return hourlyIntake.sorted { $0.hour < $1.hour }
    }
    
    func itemsGroupedByDay(nutrientType: NutrientType, items: [Item]) -> [Date: [Item]] {
            let calendar = Calendar.current
            var groupedItems = [Date: [Item]]()
            
            for item in items {
                let date = calendar.startOfDay(for: item.timestamp)
                if groupedItems[date] != nil {
                    groupedItems[date]?.append(item)
                } else {
                    groupedItems[date] = [item]
                }
            }
            
            return groupedItems
        }
        
        
        func nutrientIntakeByDay(nutrientType: NutrientType , items: [Item]) -> [(date: Date, totalIntake: Double)] {
            let groupedItems = itemsGroupedByDay(nutrientType: nutrientType, items: items)
            var dailyIntake = [(date: Date, totalIntake: Double)]()
            
            for (date, items) in groupedItems {
                let totalIntake: Double = items.reduce(0) { total, item in
                    total + (valueForNutrientType(item: item, nutrientType: nutrientType) ?? 0)
                }
                dailyIntake.append((date, totalIntake))
            }
            
            return dailyIntake.sorted { $0.date < $1.date }
        }
        
        
        private func valueForNutrientType(item: Item, nutrientType: NutrientType) -> Double? {
            switch nutrientType {
            case .calories:
                return item.nfCalories
            case .protein:
                return item.nfProtein
            case .carbohydrates:
                return item.nfTotalCarbohydrate
            
            default:
                return nil
            }
        }
    
    
    func nutrientIntakeByWeek(nutrientType: NutrientType, items: [Item]) -> [(weekOfYear: Int, averageDailyIntake: Double)] {
        let calendar = Calendar.current
        var groupedByWeek = [Int: [Item]]()

        for item in items {
            let weekOfYear = calendar.component(.weekOfYear, from: item.timestamp)
            groupedByWeek[weekOfYear, default: []].append(item)
        }

        var weeklyIntake = [(weekOfYear: Int, averageDailyIntake: Double)]()

        for (weekOfYear, items) in groupedByWeek {
            let dailyGroupedItems = itemsGroupedByDay(nutrientType: nutrientType, items: items)
            let totalIntakeForWeek: Double = dailyGroupedItems.reduce(0) { result, dailyItems in
                result + dailyItems.value.reduce(0) { total, item in
                    total + (valueForNutrientType(item: item, nutrientType: nutrientType) ?? 0)
                }
            }
            let averageDailyIntake = totalIntakeForWeek / Double(dailyGroupedItems.count)
            weeklyIntake.append((weekOfYear, averageDailyIntake))
        }

        return weeklyIntake.sorted { $0.weekOfYear < $1.weekOfYear }
    }
    
    
    func nutrientIntakeByMonth(nutrientType: NutrientType, items: [Item]) -> [(month: Int, averageDailyIntake: Double)] {
        let calendar = Calendar.current
        var groupedByMonth = [Int: [Item]]()
        
        for item in items {
            let month = calendar.component(.month, from: item.timestamp)
            groupedByMonth[month, default: []].append(item)
        }
        
        var monthlyIntake = [(month: Int, averageDailyIntake: Double)]()
        
        for (month, items) in groupedByMonth {
            let dailyGroupedItems = itemsGroupedByDay(nutrientType: nutrientType, items: items)
            let totalIntakeForMonth: Double = dailyGroupedItems.reduce(0) { result, dailyItems in
                result + dailyItems.value.reduce(0) { total, item in
                    total + (valueForNutrientType(item: item, nutrientType: nutrientType) ?? 0)
                }
            }
            let averageDailyIntake = totalIntakeForMonth / Double(dailyGroupedItems.count)
            monthlyIntake.append((month, averageDailyIntake))
        }
        
        return monthlyIntake.sorted { $0.month < $1.month }
        
        
    }
    
    func averageIntakePastSevenDays(nutrientType: NutrientType, items: [Item]) -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -6, to: today)!

        let dailyIntakes = nutrientIntakeByDay(nutrientType: nutrientType, items: items)
        let pastSevenDaysIntakes = dailyIntakes.filter { $0.date >= sevenDaysAgo && $0.date <= today }

        let totalIntake = pastSevenDaysIntakes.reduce(0) { $0 + $1.totalIntake }
        return pastSevenDaysIntakes.isEmpty ? 0 : totalIntake / Double(pastSevenDaysIntakes.count)
    }
    
    func averageIntakePastMonth(nutrientType: NutrientType, items: [Item]) -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let thirtyDaysAgo = calendar.date(byAdding: .month, value: -1, to: today)!

        let dailyIntakes = nutrientIntakeByDay(nutrientType: nutrientType, items: items)
        let pastMonthIntakes = dailyIntakes.filter { $0.date >= thirtyDaysAgo && $0.date <= today }

        let totalIntake = pastMonthIntakes.reduce(0) { $0 + $1.totalIntake }
        return pastMonthIntakes.isEmpty ? 0 : totalIntake / Double(pastMonthIntakes.count)
    }
    
    func totalIntakeToday(nutrientType: NutrientType, items: [Item]) -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let dailyIntakes = nutrientIntakeByDay(nutrientType: nutrientType, items: items)
        let todayIntake = dailyIntakes.first(where: { $0.date == today })?.totalIntake ?? 0

        return todayIntake
    }

}
