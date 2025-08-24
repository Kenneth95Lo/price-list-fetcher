//
//  Untitled.h
//  CDC_Interview
//
//  Created by Kenneth Lo on 23/8/25.
//

import Foundation
import RxSwift

@objc public class RNNativeInterviewModuleImpl: NSObject {

    private let allPriceProvider: AllPriceUseCase
    private let usdPriceProvider: USDPriceUseCase

    public override init() {
        let dependency = Dependency.shared
        self.allPriceProvider = dependency.resolve(AllPriceUseCase.self)!
        self.usdPriceProvider = dependency.resolve(USDPriceUseCase.self)!
        super.init()
    }

    @objc
    public func fetchPriceList(isEuroSupported: Bool, handler: @escaping (NSArray?, NSError?) -> Void) {

        let observable: Observable<[Any]>
        if isEuroSupported {
            observable = allPriceProvider.fetchItems().map { $0.map { Self.priceToDictionary($0) } }
        } else {
            observable = usdPriceProvider.fetchItems().map { $0.map { Self.priceToDictionary($0) } }
        }

        observable
            .take(1)
            .subscribe(
                onNext: { prices in
                    handler(prices as NSArray, nil)
                },
                onError: { error in
                    handler(nil, error as NSError)
                }
            )
    }

    private static func priceToDictionary(_ price: Any) -> NSDictionary {
        if let p = price as? USDPrice.Price {
            return [
                "id": p.id,
                "name": p.name,
                "usd": p.usd,
                "tags": p.tags,
            ]
        } else if let p = price as? AllPrice.Price {
            var dict: [String: Any] = [
                "id": p.id,
                "name": p.name,
                "usd": p.price,
                "tags": p.tags,
            ]
            dict["usd"] = p.price.usd
            dict["eur"] = p.price.eur
            return dict as NSDictionary
        }
        return [:]
    }

}
