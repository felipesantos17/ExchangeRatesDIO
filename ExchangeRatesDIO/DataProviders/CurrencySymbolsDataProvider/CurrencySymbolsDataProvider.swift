//
//  CurrencySymbolsDataProvider.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 29/10/24.
//

import Foundation

protocol CurrencySymbolsDataProviderDelegate: DataProviderManagerDelegate {
    func success(model: CurrencySymbolsObject)
}

class CurrencySymbolsDataProvider: DataProviderManager<CurrencySymbolsDataProviderDelegate, CurrencySymbolsObject> {
    private let currencyStore: CurrencyStore
    
    init(currencyStore: CurrencyStore = CurrencyStore()) {
        self.currencyStore = currencyStore
    }
    
    func fetchCurrencies() {
        Task.init {
            do {
                let model = try await currencyStore.fetchSymbols()
                delegate?.success(model: model)
            } catch {
                delegate?.errorData(delegate, error: error)
            }
        }
    }
}
