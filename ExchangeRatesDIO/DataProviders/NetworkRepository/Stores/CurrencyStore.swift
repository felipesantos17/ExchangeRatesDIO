//
//  CurrencyStore.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 29/10/24.
//

import Foundation

protocol CurrencyStoreProtocol {
    func fetchSymbols() async throws -> CurrencySymbolsObject
}

class CurrencyStore: BaseStore, CurrencyStoreProtocol {
    func fetchSymbols() async throws -> CurrencySymbolsObject {
        guard let urlRequest = try CurrencyRouter.symbols.asUrlRequest() else {
            throw error
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let symbols = try SymbolsResult(data: data, response: response).symbols else {
            throw error
        }
        return symbols
    }
}
