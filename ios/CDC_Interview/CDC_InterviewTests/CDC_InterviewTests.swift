
import XCTest
import RxTest
import RxSwift
@testable import CDC_Interview

final class CDC_InterviewTests: XCTestCase {

    var mockUSDUseCase: MockUSDPriceUseCase!
    var mockAllPriceUseCase: MockAllPriceUseCase!
    var mockDependency: Dependency!
    var mockEuroService: EuroPriceListService!
    var mockUSDService: USDPriceListService!
    
    override func setUp() {
        super.setUp()
        
        mockUSDUseCase = MockUSDPriceUseCase()
        mockAllPriceUseCase = MockAllPriceUseCase()
        mockDependency = Dependency()
        mockDependency.register(AllPriceUseCase.self) { _ in
            return self.mockAllPriceUseCase
        }
        mockDependency.register(USDPriceUseCase.self) { _ in
            return self.mockUSDUseCase
        }
        self.mockUSDService = USDPriceListService(dependency: mockDependency)
        self.mockEuroService = EuroPriceListService(dependency: mockDependency)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    override func tearDown() {
        mockEuroService = nil
        mockUSDService = nil
        mockUSDUseCase = nil
        mockAllPriceUseCase = nil
        super.tearDown()
    }

    func testEuroPriceList_SucessfullyFetchedData() async {
        // Test case for USD price list and EUR price list by feature flag
        // cover RNNativeInterviewModule.fetchPriceList()
        self.mockUSDUseCase.shouldThrowError = false
        let expectation = XCTestExpectation(description: "Handler should be called with array for USD service success.")
        
        let module = RNNativeInterviewModuleImpl(usdPriceListService: self.mockUSDService, euroPriceListService: self.mockEuroService)
        
        await module.fetchPriceList(options: ["isEuroSupported": true]) { (data, error) in
            XCTAssertNotNil(data, "Data should not be nil on success.")
            XCTAssertNil(error, "Error should not be nil on success.")
            XCTAssertEqual(data!.count, 2)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testUSDPriceList_SuccessfulyFetchedData() async {
        self.mockUSDUseCase.shouldThrowError = false
        let expectation = XCTestExpectation(description: "Handler should be called with array for USD service success.")
        
        let module = RNNativeInterviewModuleImpl(usdPriceListService: self.mockUSDService, euroPriceListService: self.mockEuroService)
        
        await module.fetchPriceList(options: ["isEuroSupported": false]) { (data, error) in
            XCTAssertNotNil(data, "Data should not be nil on success.")
            XCTAssertNil(error, "Error should be nil on success.")
            XCTAssertEqual(data!.count, 3)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testFetchPriceList_WhenUSDServiceThrowsError_CallsHandlerWithError() async {
        self.mockUSDUseCase.shouldThrowError = true
        let expectation = XCTestExpectation(description: "Handler should be called with an error for USD service failure.")
        
        let module = RNNativeInterviewModuleImpl(usdPriceListService: self.mockUSDService, euroPriceListService: self.mockEuroService)
        
        await module.fetchPriceList(options: ["isEuroSupported": false]) { (data, error) in
            XCTAssertNil(data, "Data should be nil on failure.")
            XCTAssertNotNil(error, "Error should not be nil on failure.")
            print("\((error! as NSError).domain)")
            XCTAssertEqual((error! as NSError).domain, "CDC_InterviewTests.MockError", "Error domain should match the mock error.")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testFetchPriceList_WhenEuroServiceThrowsError_CallsHandlerWithError() async {
        
        mockAllPriceUseCase.shouldThrowError = true
        let expectation = XCTestExpectation(description: "Handler should be called with an error for Euro service failure.")

        let module = RNNativeInterviewModuleImpl(usdPriceListService: self.mockUSDService, euroPriceListService: self.mockEuroService)
        await module.fetchPriceList(options: ["isEuroSupported": true]) { (data, error) in
            
            // THEN: The handler receives no data and a non-nil error
            XCTAssertNil(data, "Data should be nil on failure.")
            XCTAssertNotNil(error, "Error should not be nil on failure.")
            XCTAssertEqual((error! as NSError).domain, "CDC_InterviewTests.MockError", "Error domain should match the mock error.")
            
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}

