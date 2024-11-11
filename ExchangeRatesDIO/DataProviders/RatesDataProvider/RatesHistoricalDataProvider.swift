//
//  RatesHistoricalDataProvider.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 29/10/24.
//

import Foundation

protocol RatesHistoricalDataProviderDelegate: DataProviderManagerDelegate {
    func success(model: [RateHistoricModel])
}

class RatesHistoricalDataProvider: DataProviderManager<RatesHistoricalDataProviderDelegate, [RateHistoricModel]> {
    private let ratesStore: RatesStore
    
    init(ratesStore: RatesStore = RatesStore()) {
        self.ratesStore = ratesStore
    }
    
    func fetchTimeseries(by base: String, from symbols: [String], startDate: String, endDate: String) {
        Task.init {
            do {
                let object = try await ratesStore.fetchTimeseries(by: base, from: symbols, startDate: startDate, endDate: endDate)
                delegate?.success(model: object.flatMap({ (period, rates) -> [RateHistoricModel] in
                    return rates.map { RateHistoricModel(symbol: $0, period: period.toDate(), endRate: $1) }
                }))
            } catch {
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}
