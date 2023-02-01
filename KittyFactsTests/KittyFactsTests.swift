//
//  KittyFactsTests.swift
//  KittyFactsTests
//
//  Created by Swapnil Ratnaparkhi on 1/31/23.
//

import XCTest
@testable import KittyFacts

final class KittyFactsTests: XCTestCase {
    let kittyViewModel = KittyViewModel()

    func testKittySuccess() throws {
        let mockViewController = MockKittyViewController()
        kittyViewModel.delegate = mockViewController
        let serviceManager = KittyNetworkManager(WebAPIRequest(MockKittyProvider()))
        kittyViewModel.kittyManager = serviceManager
        let exp = expectation(description: "Details success")
        kittyViewModel.fetchKittyDetails {
            XCTAssertEqual(self.kittyViewModel.description?.data, ["All cats are beautiful."])
            XCTAssertEqual(mockViewController.isUpdateUICalled, true)
            exp.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testKittyFail() throws {
        let mockViewController = MockKittyViewController()
        kittyViewModel.delegate = mockViewController
        var mockKittyProvider = MockKittyProvider()
        mockKittyProvider.failureResponse = true
        let serviceManager = KittyNetworkManager(WebAPIRequest(mockKittyProvider))
        kittyViewModel.kittyManager = serviceManager
        let exp = expectation(description: "Details failure")
        kittyViewModel.fetchKittyDetails {
            XCTAssertEqual(self.kittyViewModel.description?.data,nil)
            XCTAssertEqual(mockViewController.isUpdateUICalled, true)
            exp.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
}

struct MockKittyProvider: APIProvider {
    typealias requestHandler = APIProvider.Handler
    var failureResponse = false
    
    func makeRequest(url: URL, completion: @escaping Handler) {
        let mockResponse = failureResponse ? nil : " { \"data\": [\"All cats are beautiful.\"] } "
        
        completion(mockResponse?.data(using: .utf8), HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil), nil)
    }
}


class MockKittyViewController: ResponseDelegate {
    var isUpdateUICalled = false
    var catViewModel: KittyViewModel?
    func updateUI() {
        isUpdateUICalled = true
    }
    
}
