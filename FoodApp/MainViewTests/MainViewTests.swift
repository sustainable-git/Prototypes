//
//  MainViewTests.swift
//  MainViewTests
//
//  Created by shin jae ung on 2022/01/01.
//

import XCTest

class MainViewTests: XCTestCase {
    var viewModel: MainViewModel!
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        let mockRepository = MockRepository()
        self.viewModel = MainViewModel(
            MainViewUseCase(
                mockRepository
            )
        )
        self.expectation = XCTestExpectation(description: "expectation")
    }

    override func tearDown() {
        self.viewModel = nil
        self.expectation = nil
        super.tearDown()
    }

    func test_음식_로드_성공() {
        self.viewModel.loadMenu{ [weak self] void in
            XCTAssertNotNil(void, "음식이 존재하지 않음")
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
    }
    
    func test_음식_로드_후_entity_not_nil() {
        self.viewModel.loadMenu{ [weak self] void in
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        XCTAssertNotNil(self.viewModel.foodEntities, "foodEntities =\(String(describing: self.viewModel.foodEntities))")
    }
    
    func test_음식_로드_갯수() {
        self.viewModel.loadMenu{ [weak self] void in
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        guard let foodEntities = self.viewModel.foodEntities else {
            XCTFail("food Entities = nil")
            return
        }
        XCTAssertEqual(foodEntities.count, 2)
    }
    
    func test_음식_로드_후_첫_entity_이름() {
        self.viewModel.loadMenu{ [weak self] void in
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        let firstTitle = self.viewModel.foodTitle(of: IndexPath(item: 0, section: 0))
        XCTAssertEqual(firstTitle, "test title 0", "첫 음식의 이름이 다름, \(String(describing: firstTitle))")
    }
    
    func test_음식_로드_후_두_번째_entity_뱃지_갯수() {
        self.viewModel.loadMenu{ [weak self] void in
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        guard let secondFoodBadges = self.viewModel.foodBadges(of: IndexPath(item: 1, section: 0)) else {
            XCTFail("두 번째 음식의 뱃지가 nil임")
            return
        }
        XCTAssertEqual(secondFoodBadges.count, 2, "두 번째 음식의 뱃지 갯수가 2가 아님, \(secondFoodBadges.count)")
    }
    
    class MockRepository: RandomFoodsRepository {
        func request(completion: @escaping (Result<[FoodEntity], Error>) -> Void) {
            let foodZero = FoodEntity(imageName: "0", title: "test title 0", badges: ["test badge 0"])
            let foodOne = FoodEntity(imageName: "1", title: "test title 1", badges: ["test badge 0", "test badge 1"])
            let foodEntities: [FoodEntity] = [foodZero, foodOne]
            completion(.success(foodEntities))
        }
    }
}
