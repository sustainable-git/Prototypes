//
//  MainViewUITest.swift
//  MainViewUITest
//
//  Created by shin jae ung on 2022/01/01.
//

import XCTest

class MainViewUITest: XCTestCase {
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
    
    func test_swipeLeft_다섯_번() {
        let scrollViewsQuery = XCUIApplication().collectionViews.scrollViews
        scrollViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.swipeLeft()
        let element = scrollViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
    }
    
    func test_swipeLeft_다섯_번_이후_swifeRight_다섯_번() {
        let scrollViewsQuery = XCUIApplication().collectionViews.scrollViews
        scrollViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.swipeLeft()
        let element = scrollViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeRight()
        element.swipeRight()
        element.swipeRight()
        element.swipeRight()
        element.swipeRight()
    }
    
    func test_reset_세_번() {
        let button = XCUIApplication().windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element
        button.tap()
        button.tap()
        button.tap()
    }
    
    func test_swipeLeft_다섯_번_이후_reset_후_swipeLeft_다섯_번() {
        let scrollViewsQuery = XCUIApplication().collectionViews.scrollViews
        scrollViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.swipeLeft()
        let element = scrollViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        let button = XCUIApplication().windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element
        button.tap()
        sleep(1)
        let element2 = scrollViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        element2.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
    }
    
    func test_첫_번째_cell_선택_후_back() {
        self.app.collectionViews.scrollViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        self.app.navigationBars["FoodApp.MenuView"].buttons["Back"].tap()
    }
    
    func test_swipeLeft_두_번_이후_cell_선택_후_back_후_swipeLeft_세_번(){
        let scrollViewsQuery = XCUIApplication().collectionViews.scrollViews
        scrollViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.swipeLeft()
        let element = scrollViewsQuery.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        self.app.collectionViews.scrollViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        self.app.navigationBars["FoodApp.MenuView"].buttons["Back"].tap()
        element.swipeLeft()
        element.swipeLeft()
        element.swipeLeft()
    }
}
