//
//  MultiCurrenciesFilterViewModel.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 11/11/24.
//

import Foundation
import SwiftUI

extension MultiCurrenciesFilterView {
    @MainActor class ViewModel: ObservableObject, CurrencySymbolsDataProviderDelegate {
        @Published var currencySymbols = [CurrencySymbolModel]()
        
        private let dataProvider: CurrencySymbolsDataProvider?
        
        init(dataProvider: CurrencySymbolsDataProvider = CurrencySymbolsDataProvider()) {
            self.dataProvider = dataProvider
            self.dataProvider?.delegate = self
        }
        
        func doFetchCurrencySymbols() {
            dataProvider?.fetchCurrencies()
        }
        
        nonisolated func success(model: [CurrencySymbolModel]) {
            DispatchQueue.main.async { [weak self] in
                withAnimation {
                    self?.currencySymbols = model.sorted { $0.symbol < $1.symbol }
                }
            }
        }
    }
}
