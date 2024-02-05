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
    
    func searchItem(with barcode: String) async throws -> FoodItem {
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "x-app-id": "YOUR_APP_ID",
                "x-app-key": "YOUR_APP_KEY",
                // Include any other headers your API requires
            ]
            
            let parameters: [String: String] = ["upc": barcode]
            
            do {
                let response = try await AF.request(baseURL, method: .get, parameters: parameters, headers: headers)
                    .validate()
                    .serializingDecodable(FoodItem.self)
                    .value
                
                return response
            } catch {
                throw error
            }
        }
    }
