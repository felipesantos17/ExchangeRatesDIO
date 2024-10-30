//
//  BaseStore.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 28/10/24.
//

import Foundation

class BaseStore {
    
    let error = NSError(domain: "", code: 901, userInfo: [NSLocalizedDescriptionKey: "Error getting information"]) as Error
    
    struct RateResult<Rates: Codable>: Codable {
        
        var base: String?
        var success: Bool = false
        var rates: Rates?
        
        init(data: Data?, response: URLResponse?) throws {
            guard let data, let response = response as? HTTPURLResponse else {
                throw NSError(domain: "", code: 901, userInfo: [NSLocalizedDescriptionKey: "Error getting information"]) as Error
            }
            
            if let url = response.url?.absoluteString,
               let json = String(data: data, encoding: .utf8) {
                print("\(url): \(json)")
                print("\(response.statusCode)")
            }
            
            self = try JSONDecoder().decode(RateResult.self, from: data)
        }
    }
    
    struct SymbolsResult: Codable {
        
        var base: String?
        var success: Bool = false
        var symbols: CurrencySymbolsObject?
        
        init(data: Data?, response: URLResponse?) throws {
            guard let data, let response = response as? HTTPURLResponse else {
                throw NSError(domain: "", code: 901, userInfo: [NSLocalizedDescriptionKey: "Error getting information"]) as Error
            }
            
            if let url = response.url?.absoluteString,
               let json = String(data: data, encoding: .utf8) {
                print("\(url): \(json)")
                print("\(response.statusCode)")
            }
            
            self = try JSONDecoder().decode(SymbolsResult.self, from: data)
        }
    }
}
