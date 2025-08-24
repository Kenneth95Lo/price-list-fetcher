
import XCTest
import RxTest
import RxSwift
@testable import CDC_Interview

final class CDC_InterviewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEuroPriceList() {
        // Test case for USD price list and EUR price list by feature flag
        // cover RNNativeInterviewModule.fetchPriceList()
        let expectation = expectation(description: "Should expect all price data format when Euro is supported")
        let isEuroSupported = true
        RNNativeInterviewModuleImpl().fetchPriceList(isEuroSupported: isEuroSupported) { prices, error in
            assert(prices?.firstObject as? AllPrice != nil)
            expectation.fulfill()
        }
    }
    
    func testUSDPriceList() {
        let expectation = expectation(description: "Should expect USD only data price format when Euro is NOT supported")
        let isEuroSupported = true
        RNNativeInterviewModuleImpl().fetchPriceList(isEuroSupported: isEuroSupported) { prices, error in
            assert(prices?.firstObject as? USDPrice != nil)
            expectation.fulfill()
        }
    }

    func testErrorHandling() {
        // Test case for error handling
    }
}

