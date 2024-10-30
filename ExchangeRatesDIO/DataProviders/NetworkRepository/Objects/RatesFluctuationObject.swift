//
//  RatesFluctuationObject.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 28/10/24.
//

import Foundation

typealias RatesFluctuationObject = [String: FluctuationObjectValue]

struct FluctuationObjectValue: Codable {
    let endRate: Double
    let change: Double
    let changePct: Double

    enum CodingKeys: String, CodingKey {
        case endRate = "end_rate"
        case change
        case changePct = "change_pct"
    }
}


