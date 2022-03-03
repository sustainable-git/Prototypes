//
//  iTunesAPIUITests.swift
//  iTunesAPIUITests
//
//  Created by shin jae ung on 2022/01/10.
//

import XCTest

class iTunesAPIUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        self.app = XCUIApplication()
        self.app.launch()
    }

    override func tearDown() {
        self.app = nil
        super.tearDown()
    }
    
    func test_Pages_검색() {
        app.navigationBars["검색"].searchFields["게임, 앱, 스토리 등"].tap()
        app.typeText("Pages")
        if app.collectionViews.staticTexts["Pages"].waitForExistence(timeout: 3) {
            app.collectionViews.staticTexts["Pages"].tap()
            app.navigationBars["iTunesAPI.DetailView"].buttons["검색"].tap()
        } else {
            XCTFail()
        }
    }
    
    func test_Pages_선택_후_썸네일_이미지_확인() {
        app.navigationBars["검색"].searchFields["게임, 앱, 스토리 등"].tap()
        app.typeText("Pages")
        if app.collectionViews.staticTexts["Pages"].waitForExistence(timeout: 3) {
            app.collectionViews.staticTexts["Pages"].tap()
            let collectionViewsQuery = XCUIApplication().collectionViews
            let scrollView = collectionViewsQuery.children(matching: .scrollView).element
            scrollView.swipeLeft()
            scrollView.swipeLeft()
            scrollView.swipeLeft()
            scrollView.swipeLeft()
            scrollView.swipeLeft()
            scrollView.swipeLeft()
            scrollView.swipeRight()
            scrollView.swipeRight()
            scrollView.swipeRight()
            scrollView.swipeRight()
            scrollView.swipeRight()
            scrollView.swipeRight()
        } else {
            XCTFail()
        }
    }
}
