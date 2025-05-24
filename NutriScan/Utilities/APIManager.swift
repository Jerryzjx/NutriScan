//
//  APIManager.swift
//  NutriScan
//
//  Created by leonard on 2024-02-04.
//

import Foundation
import Alamofire



class APIManager {
    
    static let shared = APIManager()
    
    private let baseURL = "https://trackapi.nutritionix.com/v2/search/item"
    
    func searchItem(with barcode: String) async throws -> [FoodItem] {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-app-id": "APP-ID",
            "x-app-key": "API-KEY",
        ]
        
        let parameters: [String: String] = ["upc": barcode]
        
        do {
            let response = try await AF.request(baseURL, method: .get, parameters: parameters, headers: headers)
                .validate()
                .serializingDecodable(FoodsResponse.self)
                .value
            
            return response.foods // Return the array of FoodItem
        } catch {
            throw error
        }
    }

    }
