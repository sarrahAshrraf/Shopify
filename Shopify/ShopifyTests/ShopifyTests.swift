//
//  ShopifyTests.swift
//  ShopifyTests
//
//  Created by sarrah ashraf on 01/06/2024.
//

import XCTest
@testable import Shopify

final class ShopifyTests: XCTestCase {
    var brands : [SmartCollections]?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetData(){
           let expectation = expectation(description: "API data retrieval")
           let url = URLs.shared.getBrandsURL()
           
           NetworkManger.shared.getData(url: url){ response in
               self.brands = response?.smart_collections
               XCTAssertNotNil(self.brands, "not nil")
               XCTAssertEqual(self.brands?.count , 12)
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 20)
       }
    
  
}
