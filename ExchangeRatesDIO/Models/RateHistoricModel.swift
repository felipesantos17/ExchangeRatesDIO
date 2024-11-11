//
//  RateHistoricModel.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 09/11/24.
//

import Foundation

struct RateHistoricModel: Identifiable {
    let id = UUID()
    var symbol: String
    var period: Date
    var endRate: Double
}
