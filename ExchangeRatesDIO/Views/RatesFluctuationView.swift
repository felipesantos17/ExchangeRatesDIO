//
//  RatesFluctuationView.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 30/10/24.
//

import SwiftUI

struct Fluctuation: Identifiable {
    let id = UUID()
    let symbol: String
    let change: Double
    let changePct: Double
    let endRate: Double
}

class FluctuationViewModel: ObservableObject {
    @Published var fluctuations: [Fluctuation] = [
        Fluctuation(symbol: "USD", change: 0.0008, changePct: 0.4175, endRate: 0.18857),
        Fluctuation(symbol: "EUR", change: 0.0003, changePct: 0.1651, endRate: 0.181353),
        Fluctuation(symbol: "GBP", change: -0.0001, changePct: -0.0403, endRate: 0.158915)
    ]
}

struct RatesFluctuationView: View {
    
    @StateObject var viewModel = FluctuationViewModel()
    
    @State private var searchText: String = ""
    
    var searchResult: [Fluctuation] {
        if searchText.isEmpty {
            return viewModel.fluctuations
        } else {
            return viewModel.fluctuations.filter {
                $0.symbol.contains(searchText.uppercased()) ||
                $0.change.formatter(decimalPlaces: 4).contains(searchText.uppercased()) ||
                $0.changePct.toPercentage().contains(searchText.uppercased()) ||
                $0.endRate.formatter(decimalPlaces: 2).contains(searchText.uppercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                baseCurrencyPeriodFilterView
                ratesFluctuactionListView
            }
            .searchable(text: $searchText)
            .navigationTitle("Conversão de Moedas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    print("Filtar moedas")
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
    }
    
    private var baseCurrencyPeriodFilterView: some View {
        HStack(alignment: .center, spacing: 16) {
            Button {
                print("Filtar moeda base")
            } label: {
                Text("BRL")
                    .font(.system(size: 14, weight: .bold))
                    .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .foregroundStyle(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white, lineWidth: 1)
                    )
            }
            .background(Color(UIColor.lightGray))
            .cornerRadius(8)
            
            Button {
                print("1 dia")
            } label: {
                Text("1 dia")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.blue)
                    .underline()
            }
            
            Button {
                print("7 dias")
            } label: {
                Text("7 dias")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.gray)
            }
            
            Button {
                print("1 mês")
            } label: {
                Text("1 mês")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.gray)
            }
            
            Button {
                print("6 meses")
            } label: {
                Text("6 meses")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.gray)
            }
            
            Button {
                print("1 ano")
            } label: {
                Text("1 ano")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var ratesFluctuactionListView: some View {
        List(searchResult) { fluctuation in
            VStack {
                HStack(alignment: .center, spacing: 8) {
                    Text("\(fluctuation.symbol) / BRL")
                        .font(.system(size: 14, weight: .medium))
                    Text(fluctuation.endRate.formatter(decimalPlaces: 2))
                        .font(.system(size: 14, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Text(fluctuation.change.formatter(decimalPlaces: 4, with: true))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(fluctuation.change.color)
                    Text("(\(fluctuation.changePct.toPercentage()))")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(fluctuation.change.color)
                }
                Divider()
                    .padding(.leading, -20)
                    .padding(.trailing, -40)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.white)
        }
        .listStyle(.plain)
    }
}

#Preview {
    RatesFluctuationView()
}
