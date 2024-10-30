//
//  RatesRouter.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 28/10/24.
//

import Foundation

enum RatesRouter {
    case fluctuation(base: String, symbols: [String], startDate: String, endDate: String)
    case timeseries(base: String, symbols: [String], startDate: String, endDate: String)
    
    var path: String {
        switch self {
        case .fluctuation:
            return RatesAPI.fluctuation
        case .timeseries:
            return RatesAPI.timeseries
        }
    }
    
    func asUrlRequest(_ httpMethod: HttpMethod = .get) throws -> URLRequest? {
        guard var url = URL(string: RatesAPI.baseUrl) else {
            return nil
        }
        
        switch self {
        case let .fluctuation(base, symbols, startDate, endDate):
            url = makeURLWithParameters(baseUrl: url, base: base, symbols: symbols, startDate: startDate, endDate: endDate)
        case let .timeseries(base, symbols, startDate, endDate):
            url = makeURLWithParameters(baseUrl: url, base: base, symbols: symbols, startDate: startDate, endDate: endDate)
        }
        
        var request = URLRequest(url: url.appendingPathComponent(path), timeoutInterval: Double.infinity)
        request.httpMethod = httpMethod.rawValue
        request.addValue(RatesAPI.apiKey, forHTTPHeaderField: "apikey")
        return request
    }
    
    private func makeURLWithParameters(baseUrl: URL, base: String?, symbols: [String]?, startDate: String?, endDate: String?) -> URL {
        guard let base,
              let symbols,
              let startDate,
              let endDate else {
            return baseUrl
        }
        return baseUrl.appending(queryItems: [
            URLQueryItem(name: "base", value: base),
            URLQueryItem(name: "symbols", value: symbols.joined(separator: ",")),
            URLQueryItem(name: "start_date", value: startDate),
            URLQueryItem(name: "end_date", value: endDate)
        ])
    }
}
