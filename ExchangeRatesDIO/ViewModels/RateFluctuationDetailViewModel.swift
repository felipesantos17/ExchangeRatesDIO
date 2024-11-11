//
//  RateFluctuationDetailViewModel.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 11/11/24.
//

import Foundation
import SwiftUI

extension RateFluctuationDetailView {
    @MainActor class ViewModel: ObservableObject, RatesFluctuationDataProviderDelegate, RatesHistoricalDataProviderDelegate {
        @Published var ratesFluctuation = [RateFluctuationModel]()
        @Published var ratesHistorical = [RateHistoricModel]()
        @Published var timeRange = TimeRangeEnum.today
        
        @Published var baseCurrency: String?
        @Published var rateFluctuation: RateFluctuationModel?
        
        private var fluctuationDataProvider: RatesFluctuationDataProvider?
        private var historicalDataProvider: RatesHistoricalDataProvider?
        
        var title: String {
            return "\(baseCurrency ?? "") a \(symbol)"
        }
        
        var symbol: String {
            return rateFluctuation?.symbol ?? ""
        }
        
        var endRate: Double {
            return rateFluctuation?.endRate ?? 0.0
        }
        
        var changePct: Double {
            return rateFluctuation?.changePct ?? 0.0
        }
        
        var change: Double {
            return rateFluctuation?.change ?? 0.0
        }
        
        var changeDescription: String {
            switch timeRange {
            case .today:
                return "\(change.formatter(decimalPlaces: 4, with: true)) 1 dia"
            case .thisWeek:
                return "\(change.formatter(decimalPlaces: 4, with: true)) 7 dias"
            case .thisMonth:
                return "\(change.formatter(decimalPlaces: 4, with: true)) 1 mês"
            case .thisSemester:
                return "\(change.formatter(decimalPlaces: 4, with: true)) 6 meses"
            case .thisYear:
                return "\(change.formatter(decimalPlaces: 4, with: true)) 1 ano"
            }
        }
        
        var hasRates: Bool {
            return ratesHistorical.filter { $0.endRate > 0 }.count > 0
        }
    
        var yAxisMin: Double {
            let min = ratesHistorical.map { $0.endRate }.min() ?? 0.0
            return (min - (min * 0.02))
        }
    
        var yAxisMax: Double {
            let max = ratesHistorical.map { $0.endRate }.max() ?? 0.0
            return (max + (max * 0.02))
        }
        
        init(
            fluctuationDataProvider: RatesFluctuationDataProvider = RatesFluctuationDataProvider(),
            historicalDataProvider: RatesHistoricalDataProvider = RatesHistoricalDataProvider()
        ) {
            self.fluctuationDataProvider = fluctuationDataProvider
            self.historicalDataProvider = historicalDataProvider
            self.fluctuationDataProvider?.delegate = self
            self.historicalDataProvider?.delegate = self
        }
        
        func xAxisLabelFormatStyle(for date: Date) -> String {
            switch timeRange {
            case .today:
                return date.formatter(dateFormat: "HH:mm")
            case .thisWeek, .thisMonth:
                return date.formatter(dateFormat: "dd, MMM")
            case .thisSemester:
                return date.formatter(dateFormat: "MMM")
            case .thisYear:
                return date.formatter(dateFormat: "MMM, YYYY")
            }
        }
        
        nonisolated func success(model: [RateFluctuationModel]) {
            DispatchQueue.main.async { [weak self] in
                withAnimation {
//                    self?.ratesFluctuation = model.filter { $0.symbol < $1.symbol }
                }
            }
        }
        
        nonisolated func success(model: [RateHistoricModel]) {
            DispatchQueue.main.async { [weak self] in
                withAnimation {
                    self?.ratesHistorical = model
                }
            }
        }
    }
}
