//
//  Extensions.swift
//  ExchangeRatesDIO
//
//  Created by Felipe Santos on 30/10/24.
//

import Foundation
import SwiftUICore

extension Double {
    
    var color: Color {
        if self.sign == .minus {
            return .red
        } else {
            return .green
        }
    }
    
    func formatter(decimalPlaces: Int, with changeSymbol: Bool = false) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.minimumFractionDigits = (decimalPlaces > 2) ? decimalPlaces : 2
        formatter.maximumFractionDigits = (decimalPlaces > 2) ? decimalPlaces : 2
        formatter.locale = Locale(identifier: "pt_BR")
        
        guard let value = formatter.string(from: NSNumber(value: self)) else { return String(self) }
        
        if changeSymbol {
            if self.sign == .minus {
                return "\(value)"
            } else {
                return "+\(value)"
            }
        }
        
        return value.replacingOccurrences(of: "-", with: "")
    }
    
    func toPercentage(with changeSymbol: Bool = false) -> String {
        let value = formatter(decimalPlaces: 2)
        
        if changeSymbol {
            if self.sign == .minus {
                return "\u{2193} \(value)%"
            } else {
                return "\u{2191} \(value)%"
            }
        }
        
        return "\(value)%"
    }
}

extension String {
    
    func toDate(dateFormat: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self) ?? Date()
    }
}

extension Date {
    
    init(from component: Calendar.Component, value: Int) {
        self = Calendar.current.date(byAdding: component, value: -value, to: Date()) ?? Date()
    }
    
    func formatter(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
