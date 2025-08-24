
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

    func testEuroPriceList() async {
        // Test case for USD price list and EUR price list by feature flag
        // cover RNNativeInterviewModule.fetchPriceList()
        let expectation = self.expectation(description: "Fetch All price list callback called")
            let options = ["isEuroSupported": true]
            await RNNativeInterviewModuleImpl().fetchPriceList(options: options) { array, error in
                XCTAssertNil(error, "Error should be nil")
                guard let first = array?.firstObject as? [String: Any] else {
                    XCTFail("First object is not dictionary")
                    expectation.fulfill()
                    return
                }
                XCTAssertNotNil(first["eur"])
                expectation.fulfill()
            }
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    func testUSDPriceList() async {
        let expectation = self.expectation(description: "Fetch USD price list callback called")
            let options = ["isEuroSupported": false]
            await RNNativeInterviewModuleImpl().fetchPriceList(options: options) { array, error in
                XCTAssertNil(error, "Error should be nil")
                guard let first = array?.firstObject as? [String: Any] else {
                    XCTFail("First object is not dictionary")
                    expectation.fulfill()
                    return
                }
                XCTAssertNil(first["eur"])
                expectation.fulfill()
            }
        await fulfillment(of: [expectation], timeout: 3.0)
    }

    func testErrorHandling() {
        // Test case for error handling
    }
}

