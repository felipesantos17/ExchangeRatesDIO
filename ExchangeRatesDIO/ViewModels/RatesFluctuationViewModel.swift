//
//  RatesFluctuationViewModel.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 11/11/24.
//

import Foundation
import SwiftUI

extension RatesFluctuationView {
    @MainActor class ViewModel: ObservableObject, RatesFluctuationDataProviderDelegate {
        @Published var ratesFluctuation = [RateFluctuationModel]()
        @Published var timeRange = TimeRangeEnum.today
        @Published var baseCurrency = "BRL"
        @Published var currencies = [String]()
        
        private let dataProvider: RatesFluctuationDataProvider?
        
        init(dataProvider: RatesFluctuationDataProvider = RatesFluctuationDataProvider()) {
            self.dataProvider = dataProvider
            self.dataProvider?.delegate = self
        }
        
        func doFecthRatesFluctuation(timeRange: TimeRangeEnum) {
            withAnimation { [weak self] in
                self?.timeRange = timeRange
            }
            
            let startDate = timeRange.date
            let endDate = Date()
            
            dataProvider?.fetchFluctuation(by: baseCurrency, from: currencies, startDate: startDate.toString(), endDate: endDate.toString())
        }
        
        nonisolated func success(model: [RateFluctuationModel]) {
            DispatchQueue.main.async { [weak self] in
                withAnimation {
                    self?.ratesFluctuation = model.sorted { $0.symbol < $1.symbol }
                }
            }
        }
    }
}
