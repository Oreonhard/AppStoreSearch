//
//  AppListTests.swift
//  SearchingAppStoreTests
//
//  Created by 최준찬 on 2023/09/20.
//

import XCTest

@testable import SearchingAppStore

final class AppListTests: XCTestCase {
    
    var sut: SearchingViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = SearchingViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    func testGetAppList() throws {
        let promise = XCTestExpectation(description: "App List 를 가져오는 API 실행")
        // given
        let searchKeyword = "카카오"
        
        // when
        sut.getSearchingAppList(text: searchKeyword, limit: nil)
        
        // then
        sut.bindSearchingTableView = { [weak self] in
            promise.fulfill()
            
            if let count = self?.sut.appLists.count {
                XCTAssert(0 < count && count < 51, "가져온 App list 개수가 \(count) 입니다.")
            } else {
                XCTFail("AppListTests is nil")
            }
        }
        
        wait(for: [promise], timeout: 10.0)
    }
    
    func testGetAppListWithLimit() throws {
        let promise = XCTestExpectation(description: "제한된 갯수만큼 App List 를 가져오는 API 실행")
        // given
        let searchKeyword = "카카오"
        let limit = 15
        
        // when
        sut.getSearchingAppList(text: searchKeyword, limit: limit)
        
        // then
        sut.bindSearchingTableView = { [weak self] in
            promise.fulfill()
            
            if let count = self?.sut.appLists.count {
                XCTAssert(0 < count && count < limit + 1, "가져온 App list 개수가 \(count) 입니다.")
            } else {
                XCTFail("AppListTests is nil")
            }
            
        }
        
        wait(for: [promise], timeout: 10.0)
    }
    
    func testClearAppList() throws {
        let promise = XCTestExpectation(description: "제한된 갯수만큼 App List 를 가져오는 API 실행")
        
        // given
        let searchKeyword = "카카오"
        let limit = 10
        sut.getSearchingAppList(text: searchKeyword, limit: limit)
        sut.bindSearchingTableView = {
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10.0)
        
        // when
        sut.clearAppLists()
        
        // then
        XCTAssert(sut.appLists.count == 0, "초기화 되지 않은 App list 개수가 \(sut.appLists.count) 개 입니다.")
    }
}
