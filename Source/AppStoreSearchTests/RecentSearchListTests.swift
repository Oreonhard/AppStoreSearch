//
//  RecentSearchListTests.swift
//  RecentSearchListTests
//
//  Created by 최준찬 on 2023/09/16.
//

import XCTest

@testable import SearchingAppStore

final class RecentSearchListTests: XCTestCase {
    
    var sut: RecentSearchViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RecentSearchViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    /*
     - addKeywords: 사용자가 입력한 검색어들
     - resultDatas: Core Data 내 사용자 검색어들로 5개만 가지고 있음.
     */
    func testSaveRecentSearchList() throws {
        // given
        let addKeyword = "카카오뱅크"
        
        // when
        sut.saveRecentSearchKeyword(keyword: addKeyword)
        let resultData = try sut.context.fetch(RecentSearchKeyword.fetchRequest()).reversed()[0]
        
        // then
        XCTAssertEqual(addKeyword, resultData.keyword)
    }
    
    /*
     - addKeywords: 사용자가 입력한 검색어들
     - resultDatas: Core Data 내 사용자 검색어들로 5개만 가지고 있음.
     */
    func testSaveMultipleRecentSearchList() throws {
        // given
        let addKeywords = ["카카오뱅크", "카카오페이", "카카오톡", "카카오맵", "카카오택시", "다음", "카카오"]
        let correctKeywords = ["카카오톡", "카카오맵", "카카오택시", "다음", "카카오"]
        
        // when
        addKeywords.forEach({
            sut.saveRecentSearchKeyword(keyword: $0)
        })
        let resultDatas = try sut.context.fetch(RecentSearchKeyword.fetchRequest())
        
        // then
        for i in 0...4 {
            XCTAssertEqual(correctKeywords[i], resultDatas[i].keyword)
        }
    }
    
    /*
     - addKeywords: 사용자가 입력한 검색어
     */
    func testGetRecentSearchLists() throws {
        // given
        let addKeyword = "카카오뱅크"
        
        // when
        sut.saveRecentSearchKeyword(keyword: addKeyword)
        sut.getRecentSearchKeyword()
        let getDatas = sut.recentSearchKeywords

        // then
        XCTAssert(0 < getDatas.count && getDatas.count < 6, "result의 갯수가 \(getDatas.count)개.")
        XCTAssertEqual(addKeyword, getDatas[0].keyword)
    }
    
    /*
     - addKeywords: 사용자가 입력한 검색어들
     - correctKeywords: 사용자가 입력한 검색어들의 역순 5개
                        마지막 인덱스 요소가 사용자의 마지막 검색어라서
                        recentSearchKeywords 의 최종 데이터는 Reversed 된 5개의 검색어
     */
    func testGetMultipleRecentSearchLists() throws {
        // given
        let addKeywords = ["카카오뱅크", "카카오페이", "카카오톡", "카카오맵", "카카오택시", "다음", "카카오"]
        let correctKeywords = ["카카오", "다음", "카카오택시", "카카오맵", "카카오톡"]    // 맨 뒤 인덱스부터 5개 요소
        
        // when
        addKeywords.forEach({
            sut.saveRecentSearchKeyword(keyword: $0)
        })
        sut.getRecentSearchKeyword()
        let getDatas = sut.recentSearchKeywords

        // then
        XCTAssert(0 < getDatas.count && getDatas.count < 6, "result의 갯수가 \(getDatas.count)개.")
        for i in 0...4 {
            XCTAssertEqual(correctKeywords[i], getDatas[i].keyword)
        }
    }
}
