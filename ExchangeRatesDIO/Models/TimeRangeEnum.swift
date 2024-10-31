//
//  TimeRangeEnum.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 31/10/24.
//

import Foundation

enum TimeRangeEnum {
    case today
    case thisWeek
    case thisMonth
    case thisSemester
    case thisYear
    
    var date: Date {
        switch self {
        case .today:
            return Date(from: .day, value: 1)
        case .thisWeek:
            return Date(from: .day, value: 6)
        case .thisMonth:
            return Date(from: .month, value: 1)
        case .thisSemester:
            return Date(from: .month, value: 6)
        case .thisYear:
            return Date(from: .year, value: 1)
        }
    }
}
