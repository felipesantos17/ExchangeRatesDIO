//
//  RateFluctuationDetailView.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 31/10/24.
//

import SwiftUI
import Charts

struct ChartComparation: Identifiable, Equatable {
    let id = UUID()
    var symbol: String
    var period: Date
    var endRate: Double
}

class RateFluctuationDetailViewModel: ObservableObject {
    @Published var fluctuations: [Fluctuation] = [
        Fluctuation(symbol: "USD", change: 0.0008, changePct: 0.4175, endRate: 0.18857),
        Fluctuation(symbol: "EUR", change: 0.0003, changePct: 0.1651, endRate: 0.181353),
        Fluctuation(symbol: "GBP", change: -0.0001, changePct: -0.0403, endRate: 0.158915)
    ]
    @Published var chartComparations: [ChartComparation] = [
        ChartComparation(symbol: "USD", period: "2020-11-13".toDate(), endRate: 0.18857),
        ChartComparation(symbol: "USD", period: "2020-11-12".toDate(), endRate: 0.187657),
        ChartComparation(symbol: "USD", period: "2020-11-11".toDate(), endRate: 0.189786),
        ChartComparation(symbol: "USD", period: "2020-11-10".toDate(), endRate: 0.197073)
    ]
    
    @Published var timeRange = TimeRangeEnum.today
    
    var hasRates: Bool {
        return chartComparations.filter { $0.endRate > 0 }.count > 0
    }
    
    var yAxisMin: Double {
        let min = chartComparations.map { $0.endRate }.min() ?? 0.0
        return (min - (min * 0.02))
    }
    
    var yAxisMax: Double {
        let max = chartComparations.map { $0.endRate }.max() ?? 0.0
        return (max + (max * 0.02))
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
}

struct RateFluctuationDetailView: View {
    
    @StateObject var viewModel = RateFluctuationDetailViewModel()
    
    @State var baseCurrency: String
    @State var rateFluctuation: Fluctuation
    @State private var isPresentedBaseCurrencyFilter = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            valuesView
            graphicChartView
            comparationView
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .navigationTitle("BRL a EUR")
    }
    
    private var valuesView: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(rateFluctuation.endRate.formatter(decimalPlaces: 4))
                .font(.system(size: 28, weight: .bold))
            Text(rateFluctuation.changePct.toPercentage(with: true))
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(rateFluctuation.changePct.color)
                .background(rateFluctuation.changePct.color.opacity(0.2))
            Text(rateFluctuation.change.formatter(decimalPlaces: 4, with: true))
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(rateFluctuation.change.color)
            Spacer()
        }
        .padding(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
    
    private var graphicChartView: some View {
        VStack {
            periodFilterView
            lineChartView
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
    
    private var periodFilterView: some View {
        HStack(alignment: .center, spacing: 16) {
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
    
    private var lineChartView: some View {
        Chart(viewModel.chartComparations) { item in
            LineMark(
                x: .value("Period", item.period),
                y: .value("Rates", item.endRate)
            )
            .interpolationMethod(.catmullRom)
            
            if !viewModel.hasRates {
                RuleMark(
                    y: .value("Conversão Zero", 0)
                )
                .annotation(position: .overlay, alignment: .center) {
                    Text("Sem valores nesse período")
                        .font(.footnote)
                        .padding()
                        .background(Color(UIColor.systemBackground))
                }
            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned) { date in
                AxisGridLine()
                AxisValueLabel(viewModel.xAxisLabelFormatStyle(for: date.as(Date.self) ?? Date())
                )
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { rate in
                AxisGridLine()
                AxisValueLabel(rate.as(Double.self)?.formatter(decimalPlaces: 3) ?? 0.0.formatter(decimalPlaces: 3))
            }
        }
        .chartYScale(domain: viewModel.yAxisMin...viewModel.yAxisMax)
        .frame(height: 260)
        .padding(.trailing, 18)
    }
    
    private var comparationView: some View {
        VStack(spacing: 8) {
            comparationButtonView
            comparationScrollView
            Spacer()
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
    
    private var comparationButtonView: some View {
        Button {
            isPresentedBaseCurrencyFilter.toggle()
        } label: {
            Image(systemName: "magnifyingglass")
            Text("Comparar com")
                .font(.system(size: 16))
        }
        .fullScreenCover(isPresented: $isPresentedBaseCurrencyFilter, content: {
            BaseCurrencyFilterView()
        })
    }
    
    private var comparationScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())], alignment: .center) {
                ForEach(viewModel.fluctuations) { fluctuation in
                    Button {
                        print("Comparação")
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(fluctuation.symbol) / \(baseCurrency)")
                                .font(.system(size: 14))
                                .foregroundStyle(.black)
                            Text(fluctuation.endRate.formatter(decimalPlaces: 4))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.black)
                            HStack(alignment: .bottom, spacing: 60) {
                                Text(fluctuation.symbol)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.gray)
                                Text(fluctuation.changePct.toPercentage())
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(fluctuation.changePct.color)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    RateFluctuationDetailView(baseCurrency: "BR", rateFluctuation: Fluctuation(symbol: "EUR", change: 0.0003, changePct: 0.1651, endRate: 0.181353))
}
