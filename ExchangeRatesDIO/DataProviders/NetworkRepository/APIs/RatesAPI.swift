//
//  RatesAPI.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 28/10/24.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
}

struct RatesAPI {
    static let baseUrl = "https://api.apilayer.com/exchangerates_data/"
    static let apiKey = "nHn03PiUWaSbR5Ag9UtiZNU9wele21AE"
    static let symbols = "symbols"
    static let fluctuation = "fluctuation"
    static let timeseries = "timeseries"
}
