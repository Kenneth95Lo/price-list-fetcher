//
//  Mocks.swift
//  CDC_Interview
//
//  Created by Kenneth Lo on 24/8/25.
//

import Foundation
@testable import CDC_Interview

enum MockError: Error, LocalizedError {
    case networkError
    
    var errorDescription: String? {
        return "Test network error failure"
    }
}

class MockUSDPriceUseCase: USDPriceUseCase {
    var shouldThrowError = false
    
    override func fetchItemsAsync() async throws -> [USDPrice.Price] {
        if shouldThrowError {
            throw MockError.networkError
        }
        // Return empty array for success cases if not testing success
        return [
            USDPrice.Price(id: 0, name: "BTC", usd: 88.88, tags: [.withdrawal]),
            USDPrice.Price(id: 1, name: "ETH", usd: 77.88, tags: [.withdrawal, .deposit]),
            USDPrice.Price(id: 2, name: "SOL", usd: 66.88, tags: [.deposit])
        ]
    }
}

class MockAllPriceUseCase: AllPriceUseCase {
    var shouldThrowError = false
    
    override func fetchItemsAsync() async throws -> [AllPrice.Price] {
        if shouldThrowError {
            throw MockError.networkError
        }
        return [
            AllPrice.Price(id: 0, name: "BTC", price: AllPrice.Price.PriceRecord(usd: 100.00, eur: 101.11), tags: [.deposit, .withdrawal]),
            AllPrice.Price(id: 1, name: "eth", price: AllPrice.Price.PriceRecord(usd: 99.00, eur: 222.11), tags: [.deposit])
        ] as [AllPrice.Price]
    }
}
