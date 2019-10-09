//
//  autoSampleTests.swift
//  autoSampleTests
//
//  Created by Jesus Alberto on 10/6/19.
//  Copyright © 2019 Jesus. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import Moya
@testable import autoSample

class autoSampleTests: XCTestCase {

    private var provider: MoyaProvider<AutoAPI>!
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        provider =  MoyaProvider<AutoAPI>.init(stubClosure: MoyaProvider<AutoAPI>.immediatelyStub)
    }
    
    func test_AutoAPI_getManufacturers_ShouldBeEqualTo() {
        var manufacturer = Manufacturer()
        let expectedCount: Int = 10
        let expecteFirstBrand: String = "Abarth"
        let expectation =  self.expectation(description: "start fetching manufacturers")
        provider.rx.request(.getManufacturer(page: 0, pageSize: 10))
            .map(Manufacturer.self)
            .asObservable()
            .subscribe(onNext: { list in
                manufacturer = list
                manufacturer.type = list.type.sorted { $0.id < $1.id }
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        XCTAssertEqual(manufacturer.type.count, expectedCount)
        XCTAssertEqual(manufacturer.type.first?.name, expecteFirstBrand)
    }
    
    
    func test_AutoAPI_getCarList_ShouldBeEqualTo() {
        var cartType = CarType()
        let expectedCount: Int = 6
        let expecteFirstBrand: String = "Arnage"
        let expectation =  self.expectation(description: "start fetching cars")
        provider.rx.request(.getType(manufacturerId: "108", page: 0, pageSize: 10))
            .map(CarType.self)
            .asObservable()
            .subscribe(onNext: { list in
                cartType = list
                cartType.type = list.type.sorted { $0.id < $1.id }
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5) { error in
            if (error != nil) {
                XCTFail("sample data fail")
            }
        }
        XCTAssertEqual(cartType.type.count, expectedCount)
        XCTAssertEqual(cartType.type.first?.name, expecteFirstBrand)
    }
}
