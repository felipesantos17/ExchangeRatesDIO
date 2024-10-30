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
