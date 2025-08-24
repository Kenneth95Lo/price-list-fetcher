//
//  Untitled.h
//  CDC_Interview
//
//  Created by Kenneth Lo on 23/8/25.
//

import Foundation
import RxSwift

@objc public class RNNativeInterviewModuleImpl: NSObject {

    public override init() {
        super.init()
    }
    
    public typealias FetchPriceOptions = [String: Any]

    @objc
    public func fetchPriceList(options: FetchPriceOptions, handler: @escaping (NSArray?, NSError?) -> Void) async {
        
        var fetchable: any Fetchable = USDPriceListService()
        
        if (options["isEuroSupported"] != nil && options["isEuroSupported"] as! Bool) {
            fetchable = EuroPriceListService()
        }
        
        do {
            let res = try await fetchable.fetchPriceList()
            switch res {
            case let prices as [AllPrice.Price]:
                let dictArr = prices.map { $0.toDictionary() } as? NSArray
                handler(dictArr, nil)
            case let prices as [USDPrice.Price]:
                let dictArr = prices.map { $0.toDictionary() } as? NSArray
                handler(dictArr, nil)
            default:
                handler(nil, NSError(domain: "Unable to parsse data", code: 0))
            }
        }catch {
            handler(nil, error as NSError)
        }
    }
}

