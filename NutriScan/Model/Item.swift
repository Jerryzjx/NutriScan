//
//  Item.swift
//  NutriScan
//
//  Created by leonard on 2024-01-30.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var name: String
    var brandName: String
    
    
    init(timestamp: Date, name: String, brandName: String) {
        self.timestamp = timestamp
        self.name = name
        self.brandName = brandName
    }
}
