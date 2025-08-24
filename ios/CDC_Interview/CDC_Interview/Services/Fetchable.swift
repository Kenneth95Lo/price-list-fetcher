//
//  Fetchable.swift
//  CDC_Interview
//
//  Created by Kenneth Lo on 24/8/25.
//

protocol Fetchable {
    associatedtype Result
    func fetchPriceList() async throws -> [Result]
}

class USDPriceListService: Fetchable {
    
    private let dependency: Dependency
    private let provider: USDPriceUseCase
    
    init(dependency: Dependency = Dependency.shared){
        self.dependency = dependency
        self.provider = dependency.resolve(USDPriceUseCase.self)!
    }
    
    func fetchPriceList() async throws -> [USDPrice.Price] {
        return try await provider.fetchItemsAsync()
    }
}

class EuroPriceListService: Fetchable {
    
    private let dependency: Dependency
    private let provider: AllPriceUseCase
    
    init(dependency: Dependency = Dependency.shared) {
        self.dependency = dependency
        self.provider = dependency.resolve(AllPriceUseCase.self)!
    }
    
    func fetchPriceList() async throws -> [AllPrice.Price] {
        return try await provider.fetchItemsAsync()
    }
    
}
