//
//  RateFluctuationModel.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 09/11/24.
//

import Foundation

struct RateFluctuationModel: Identifiable {
    let id = UUID()
    let symbol: String
    let change: Double
    let changePct: Double
    let endRate: Double
}
