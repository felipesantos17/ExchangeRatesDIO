//
//  CurrencyRouter.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 28/10/24.
//

import Foundation

enum CurrencyRouter {
    
    case symbols
    
    var path: String {
        switch self {
        case .symbols:
            return RatesAPI.symbols
        }
    }
    
    func asUrlRequest(_ httpMethod: HttpMethod = .get) throws -> URLRequest? {
        guard let url = URL(string: RatesAPI.baseUrl) else {
            return nil
        }
        
        switch self {
        case .symbols:
            var request = URLRequest(url: url.appendingPathComponent(path), timeoutInterval: Double.infinity)
            request.httpMethod = httpMethod.rawValue
            request.addValue(RatesAPI.apiKey, forHTTPHeaderField: "apikey")
            return request
        }
    }
}
