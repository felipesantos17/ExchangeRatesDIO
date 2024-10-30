//
//  ContentView.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 28/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button {
                doFetch()
            } label: {
                Image(systemName: "network")
            }
        }
        .padding()
    }
    
    private func doFetch() {
        let ratesFluctuation = RatesFluctuationDataProvider()
        ratesFluctuation.delegate = self
        ratesFluctuation.fetchFluctuation(by: "BRL", from: ["USD, EUR"], startDate: "2022-10-11", endDate: "2022-10-11")
        
        let rateSymbols = CurrencySymbolsDataProvider()
        rateSymbols.delegate = self
        rateSymbols.fetchCurrencies()
        
        let ratesHistorical = RatesHistoricalDataProvider()
        ratesHistorical.delegate = self
        ratesHistorical.fetchTimeseries(by: "BRL", from: ["USD, EUR"], startDate: "2022-10-11", endDate: "2022-10-11")
    }
}

extension ContentView: RatesFluctuationDataProviderDelegate {
    func success(model: RatesFluctuationObject) {
        print("Rates Fluctuaction \(model)")
    }
}

extension ContentView: CurrencySymbolsDataProviderDelegate {
    func success(model: CurrencySymbolsObject) {
        print("Rates Symbols \(model)")
    }
}

extension ContentView: RatesHistoricalDataProviderDelegate {
    func success(model: RatesHistoricalObject) {
        print("Rates Historical FELIPE:: \(model)")
    }
}

#Preview {
    ContentView()
}
