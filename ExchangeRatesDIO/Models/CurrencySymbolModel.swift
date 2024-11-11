//
//  CurrencySymbolModel.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 09/11/24.
//

import Foundation

struct CurrencySymbolModel: Identifiable {
    let id = UUID()
    var symbol: String
    var fullName: String
}
