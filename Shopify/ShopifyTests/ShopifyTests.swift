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
    
    func testPostData() {
        let url = URLs.shared.getAddressURL()
        let expectation = XCTestExpectation(description: "postData completion handler called")

        let address = Address(
                    id: nil,
                    customer_id: nil,
                    name: "John Doe",
                    first_name: "John",
                    last_name: "Doe",
                    phone: "123-456-7890",
                    company: "ACME Corp",
                    address1: "123 Main St",
                    address2: "Apt 4",
                    city: "Anytown",
                    province: "Anyprovince",
                    country: "Anycountry",
                    zip: "12345",
                    province_code: "AP",
                    country_code: "AC",
                    country_name: "Anycountry",
                    default: true
                )
        let addressDict: [String: Any] = [
            "address1": address.address1 ?? "",
            "address2": address.address2 ?? "",
            "city": address.city ?? "",
            "company": address.company ?? "",
            "first_name": address.first_name ?? "",
            "last_name": address.last_name ?? "",
            "phone": address.phone ?? "",
            "province": address.province ?? "",
            "country": address.country ?? "",
            "zip": address.zip ?? "",
            "name": address.name ?? "",
            "province_code": address.province_code ?? "",
            "country_code": address.country_code ?? "",
            "country_name": address.country_name ?? "",
            "default": address.default ?? false
        ]
        let finalDict: [String: Any] = ["address": addressDict]

        NetworkManger.shared.postData(path: url , parameters: finalDict) { response, statusCode in
            
            if let statusCode = statusCode, (200...299).contains(statusCode) {
                XCTAssert(true)
            } else {
                print("failed")
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 50)
    }
    
    func testPutData() {
            let customerId = 123
            let addressId = 456
            let url = URLs.shared.getAddressURLForModification(customerID: String(customerId), addressID: String(addressId))
            let expectation = XCTestExpectation(description: "postData completion handler called")

            let address = Address(
                        id: nil,
                        customer_id: nil,
                        name: "John Doe",
                        first_name: "John",
                        last_name: "Doe",
                        phone: "123-456-7890",
                        company: "ACME Corp",
                        address1: "123 Main St",
                        address2: "Apt 4",
                        city: "Anytown",
                        province: "Anyprovince",
                        country: "Anycountry",
                        zip: "12345",
                        province_code: "AP",
                        country_code: "AC",
                        country_name: "Anycountry",
                        default: true
                    )
            let addressDict: [String: Any] = [
                "address1": address.address1 ?? "",
                "address2": address.address2 ?? "",
                "city": address.city ?? "",
                "company": address.company ?? "",
                "first_name": address.first_name ?? "",
                "last_name": address.last_name ?? "",
                "phone": address.phone ?? "",
                "province": address.province ?? "",
                "country": address.country ?? "",
                "zip": address.zip ?? "",
                "name": address.name ?? "",
                "province_code": address.province_code ?? "",
                "country_code": address.country_code ?? "",
                "country_name": address.country_name ?? "",
                "default": address.default ?? false
            ]
            let finalDict: [String: Any] = ["address": addressDict]

            NetworkManger.shared.putData(path: url , parameters: finalDict) { response, statusCode in
                // Verify the response and status code
                if let statusCode = statusCode, (200...299).contains(statusCode) {
                    XCTAssert(true)
                } else {
                    print("failed")
                }

                expectation.fulfill()
            }

            // Wait for the expectation to be fulfilled
            wait(for: [expectation], timeout: 20)
        }


}
