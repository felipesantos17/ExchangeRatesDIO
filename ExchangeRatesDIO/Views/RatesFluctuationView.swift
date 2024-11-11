//
//  RatesFluctuationView.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 30/10/24.
//

import SwiftUI

struct RatesFluctuationView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State private var searchText: String = ""
    @State private var viewDidLoad = true
    @State private var isPresentedBaseCurrencyFilter = false
    @State private var isPresentedMultiCurrencyFilter = false
    
    var searchResult: [RateFluctuationModel] {
        if searchText.isEmpty {
            return viewModel.ratesFluctuation
        } else {
            return viewModel.ratesFluctuation.filter {
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
                    isPresentedMultiCurrencyFilter.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .fullScreenCover(isPresented: $isPresentedMultiCurrencyFilter) {
                    MultiCurrenciesFilterView(delegate: self)
                }
            }
        }
        .onAppear {
            if viewDidLoad {
                viewDidLoad.toggle()
                viewModel.doFecthRatesFluctuation(timeRange: .today)
            }
        }
    }
    
    private var baseCurrencyPeriodFilterView: some View {
        HStack(alignment: .center, spacing: 16) {
            Button {
                isPresentedBaseCurrencyFilter.toggle()
            } label: {
                Text(viewModel.baseCurrency)
                    .font(.system(size: 14, weight: .bold))
                    .padding(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .foregroundStyle(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.white, lineWidth: 1)
                    )
            }
            .fullScreenCover(isPresented: $isPresentedBaseCurrencyFilter, content: {
                BaseCurrencyFilterView(delegate: self)
            })
            .background(Color(UIColor.lightGray))
            .cornerRadius(8)
            
            Button {
                viewModel.doFecthRatesFluctuation(timeRange: .today)
            } label: {
                Text("1 dia")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(viewModel.timeRange == .today ? .blue : .gray)
                    .underline(viewModel.timeRange == .today)
            }
            
            Button {
                viewModel.doFecthRatesFluctuation(timeRange: .thisWeek)
            } label: {
                Text("7 dias")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(viewModel.timeRange == .thisWeek ? .blue : .gray)
                    .underline(viewModel.timeRange == .thisWeek)
            }
            
            Button {
                viewModel.doFecthRatesFluctuation(timeRange: .thisMonth)
            } label: {
                Text("1 mês")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(viewModel.timeRange == .thisMonth ? .blue : .gray)
                    .underline(viewModel.timeRange == .thisMonth)
            }
            
            Button {
                viewModel.doFecthRatesFluctuation(timeRange: .thisSemester)
            } label: {
                Text("6 meses")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(viewModel.timeRange == .thisSemester ? .blue : .gray)
                    .underline(viewModel.timeRange == .thisSemester)
            }
            
            Button {
                viewModel.doFecthRatesFluctuation(timeRange: .thisYear)
            } label: {
                Text("1 ano")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(viewModel.timeRange == .thisYear ? .blue : .gray)
                    .underline(viewModel.timeRange == .thisYear)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var ratesFluctuactionListView: some View {
        List(searchResult) { fluctuation in
            NavigationLink(destination: RateFluctuationDetailView(baseCurrency: "BRL", rateFluctuation: fluctuation)) {
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
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.white)
        }
        .listStyle(.plain)
    }
}

extension RatesFluctuationView: BaseCurrencyFilterDelegate {
    func didSelect(_ baseCurrency: String) {
        viewModel.baseCurrency = baseCurrency
        viewModel.doFecthRatesFluctuation(timeRange: .today)
    }
}

extension RatesFluctuationView: MultiCurrenciesFilterViewDelegate {
    func didSelected(_ currencies: [String]) {
        viewModel.currencies = currencies
        viewModel.doFecthRatesFluctuation(timeRange: .today)
    }
}

#Preview {
    RatesFluctuationView()
}
