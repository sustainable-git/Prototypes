//
//  MainViewTest.swift
//  MainViewTest
//
//  Created by shin jae ung on 2022/01/10.
//

import XCTest

class MainViewTest: XCTestCase {
    var viewModel: MainViewModel!
    var expectation: XCTestExpectation!

    override func setUp() {
        super.setUp()
        let appStoreFetchModkRepository = AppStoreFetchMockRepository()
        let imageDownloadMockRepository = ImageDownloadMockRepository()
        self.viewModel = MainViewModel(
            AppStoreFetchUseCase(appStoreFetchModkRepository),
            ImageFetchUseCase(imageDownloadMockRepository)
        )
        self.expectation = XCTestExpectation(description: "expectation")
    }

    override func tearDown() {
        self.viewModel = nil
        self.expectation = nil
        super.tearDown()
    }
    
    func test_검색_후_applications_할당() {
        self.viewModel.search("Pages") { [weak self] void in
            XCTAssertNotNil(void, "search에서 nil이 반환됨")
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        XCTAssertNotNil(self.viewModel.applications, "applications가 반환되지 않음")
    }
    
    func test_검색_후_appInfo_title_확인() {
        self.viewModel.search("Pages") { [weak self] void in
            XCTAssertNotNil(void, "search에서 nil이 반환됨")
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        XCTAssertNotNil(self.viewModel.applications, "applications가 반환되지 않음")
        guard let appInfo = self.viewModel.appInfo(of: IndexPath(item: 0, section: 0)) else {
            XCTFail("appInfo가 nil임")
            return
        }
        XCTAssertEqual(appInfo.title, MockConstant.title, "title이 다름, \(MockConstant.title) != \(appInfo.title)")
    }
    
    func test_검색_후_appInfo_price_확인() {
        self.viewModel.search("Pages") { [weak self] void in
            XCTAssertNotNil(void, "search에서 nil이 반환됨")
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        XCTAssertNotNil(self.viewModel.applications, "applications가 반환되지 않음")
        guard let appInfo = self.viewModel.appInfo(of: IndexPath(item: 0, section: 0)) else {
            XCTFail("appInfo가 nil임")
            return
        }
        XCTAssertEqual(appInfo.price, MockConstant.price, "price가 다름, \(MockConstant.price) != \(appInfo.price)")
    }
    
    func test_검색_후_appInfo_rating_확인() {
        self.viewModel.search("Pages") { [weak self] void in
            XCTAssertNotNil(void, "search에서 nil이 반환됨")
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        XCTAssertNotNil(self.viewModel.applications, "applications가 반환되지 않음")
        guard let appInfo = self.viewModel.appInfo(of: IndexPath(item: 0, section: 0)) else {
            XCTFail("appInfo가 nil임")
            return
        }
        XCTAssertEqual(appInfo.rating, String(format: "별점 : %.2f", MockConstant.rating), "rating이 다름, \(appInfo.rating) != \(String(format: "별점 : %.2f", MockConstant.rating))")
    }
    
    func test_검색_후_image_불러오기() {
        self.viewModel.search("Pages") { [weak self] void in
            XCTAssertNotNil(void, "search에서 nil이 반환됨")
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        XCTAssertNotNil(self.viewModel.applications, "applications가 반환되지 않음")
        
        self.expectation = XCTestExpectation(description: "expectation")
        
        _ = self.viewModel.image(of: IndexPath(item: 0, section: 0)) { [weak self] url in
            XCTAssertNotNil(url, "image의 url에서 nil이 반환됨")
            XCTAssertEqual(url!.absoluteString, MockConstant.thumbnailURL, "url이 다름, \(MockConstant.thumbnailURL) != \(url!.absoluteString)")
            self?.expectation.fulfill()
        }
        self.wait(for: [self.expectation], timeout: 1.0)
        
    }

    class AppStoreFetchMockRepository: AppStoreFetchable {
        func fetchApplications(_ string: String, completion: @escaping (Result<Applications, Error>) -> Void) {
            let apps: [App] = [App(
                thumbnailURL: MockConstant.thumbnailURL,
                title: MockConstant.title,
                price: MockConstant.price,
                rating: MockConstant.rating,
                details: MockConstant.details,
                screenShotURLs: MockConstant.screenShotURLs
            )]
            let applications: Applications = Applications(count: 1, apps: apps)
            completion(.success(applications))
        }
    }
    
    class ImageDownloadMockRepository: ImageDownloadable {
        func fetchImageURL(_ string: String, completion: @escaping (Result<URL, Error>) -> Void) -> URLSessionDownloadTask? {
            guard let url = URL(string: MockConstant.thumbnailURL) else { return nil }
            completion(.success(url))
            return nil
        }
    }
    
    enum MockConstant {
        static var thumbnailURL: String {
            "https://picsum.photos/80/80"
        }
        static var title: String { "Pages" }
        static var price: String { "무료" }
        static var rating: Double { 4.50123 }
        static var details: String {
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        }
        static var screenShotURLs: [String] {
            ["https://picsum.photos/200/300", "https://picsum.photos/200/300", "https://picsum.photos/200/300"]
        }
    }
}
