//
//  SearchingAppStoreUITests.swift
//  SearchingAppStoreUITests
//
//  Created by 최준찬 on 2023/09/16.
//

import XCTest

final class SearchingAppStoreUITests: XCTestCase {
    
    var app: XCUIApplication!
    var searchBar: XCUIElement!
    var recentSearchList: XCUIElement!
    var searchList: XCUIElement!
    var appDetailView: XCUIElement!
    var appPreviews: XCUIElement!
    var appFullPreview: XCUIElement!
    var appFullPreviewCloseButton: XCUIElement!
    var descriptionCell: XCUIElement!
    var releaseNoteCell: XCUIElement!
    var descriptionMoreButton: XCUIElement!
    var releaseNoteMoreButton: XCUIElement!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        searchBar = app.navigationBars["searchNavigationBar"]
        recentSearchList = app.tables["recentSearchList"]
        searchList = app.tables["searchList"]
        appDetailView = app.tables["appDetailView"]
        appPreviews = app.collectionViews["appPreviews"]
        appFullPreview = app.collectionViews["appFullPreview"]
        appFullPreviewCloseButton = app.buttons["appFullPreviewCloseButton"]
        descriptionCell = app.cells["descriptionCell"]
        releaseNoteCell = app.cells["releaseNoteCell"]
        descriptionMoreButton = app.buttons["descriptionMoreButton"]
        releaseNoteMoreButton = app.buttons["releaseNoteMoreButton"]
        
        continueAfterFailure = false
        
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAppSearchAndEnter() throws {
        let searchField = searchBar.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("카카오뱅크\n")
        
        let resultCellOfFirst = searchList.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 10.0))
    }
    
    func testAppSearchAndClickAutoKeyword() throws {
        let searchField = searchBar.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("카카오뱅크")
        
        let searchCellOfFirst = searchList.cells.firstMatch
        XCTAssertTrue(searchCellOfFirst.waitForExistence(timeout: 10.0))
        
        searchCellOfFirst.tap()
        
        let listCellOfFirst = searchList.cells.firstMatch
        XCTAssertTrue(listCellOfFirst.waitForExistence(timeout: 10.0))
    }
    
    func testClickRecentSearchList() throws {
        let recentSearchofFirstCell = recentSearchList.cells.firstMatch
        XCTAssertTrue(recentSearchofFirstCell.waitForExistence(timeout: 10.0))
        
        recentSearchofFirstCell.tap()
        
        let listCellOfFirst = searchList.cells.firstMatch
        XCTAssertTrue(listCellOfFirst.waitForExistence(timeout: 10.0))
    }
    
    func testOpenAppDatailView() throws {
        let searchField = searchBar.searchFields.firstMatch
        XCTAssertTrue(searchField.exists)
        
        searchField.tap()
        searchField.typeText("카카오뱅크")
        
        let searchCellOfFirst = searchList.cells.firstMatch
        XCTAssertTrue(searchCellOfFirst.waitForExistence(timeout: 10.0))
        
        searchCellOfFirst.tap()
        
        let listCellOfFirst = searchList.cells.firstMatch
        XCTAssertTrue(listCellOfFirst.waitForExistence(timeout: 10.0))
        
        listCellOfFirst.tap()
        XCTAssertTrue(appDetailView.waitForExistence(timeout: 3.0))
        
        XCTAssertTrue(appPreviews.exists)
        
        appPreviews.cells.firstMatch.tap()
        XCTAssertTrue(appFullPreview.exists)
        
        appFullPreviewCloseButton.tap()
        
        appDetailView.swipeUp()
        
        XCTAssertTrue(descriptionMoreButton.waitForExistence(timeout: 3.0))
        
        let originalHeightDescription = descriptionCell.frame.height
        descriptionMoreButton.tap()
        XCTAssert(descriptionCell.frame.height > originalHeightDescription)
        
        appDetailView.swipeUp()
        
        XCTAssertTrue(releaseNoteMoreButton.waitForExistence(timeout: 3.0))
        let originalHeightReleaseNote = releaseNoteCell.frame.height
        releaseNoteMoreButton.tap()
        
        XCTAssert(releaseNoteCell.frame.height > originalHeightReleaseNote)
    }
}
