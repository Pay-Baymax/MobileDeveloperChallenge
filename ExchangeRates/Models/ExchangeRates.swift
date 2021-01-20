//
//  ExchangeRates.swift
//  ExchangeRates
//
//  Created by Aim on 19/01/21.
//

import Foundation

// MARK: - ExchangeRates
struct ExchangeRates: Codable {
    let success: Bool
    let terms, privacy: String
    let timestamp: Int
    let source: String
    let quotes: [String: Double]
}
