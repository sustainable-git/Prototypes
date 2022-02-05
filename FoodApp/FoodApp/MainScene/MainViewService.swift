//
//  MainViewService.swift
//  FoodApp
//
//  Created by shin jae ung on 2021/12/31.
//

import UIKit

protocol NetworkService {
    func randomFoodsRequest(completion: @escaping (Result<[[String]], Error>) -> Void)
}

final class MainViewService: NetworkService {
    enum ServiceError: String, Error {
        case randomResultNotExists
    }
    
    enum Assets: Int, CaseIterable {
        case zero = 0, one = 1, two = 2, three = 3, four = 4,
             five = 5, six = 6, seven = 7, eight = 8, nine = 9
        
        func string() -> [String] {
            switch self {
            case .zero: return ["0", "푸아그라", "프랑스 북동부", "서양 3대 진미", "코스 요리"]
            case .one: return ["1", "피자", "쫄깃한 도우", "푸짐한 토핑", "쭈욱 늘어나는 피자치즈"]
            case .two: return ["2", "파스타", "로맨틱 이태리", "봉대박 스파게티", "도로시 파스타"]
            case .three: return ["3", "짜장면", "간짜장", "곱빼기 가능", "고기 많음"]
            case .four: return ["4", "부대찌개", "Army Stew", "사리 추가 가능", "추운 날씨에는 칼칼한 부대찌개"]
            case .five: return ["5", "삼겹살", "드라마 단돌 메뉴, K-Food의 대명사", "상추 쌈 싸먹자"]
            case .six: return ["6", "칼국수", "풍성한 해산물", "면을 육수와 함께 끓여내 국물이 진하다",]
            case .seven: return ["7", "타코", "정통 멕시칸푸드", "살사소스"]
            case .eight: return ["8", "스시", "일본 장인의 손맛"]
            case .nine: return ["9", "닭꼬치"]
            }
        }
    }
    
    func randomFoodsRequest(completion: @escaping (Result<[[String]], Error>) -> Void) {
        var randomSixResult: Set<Assets> = []
        while randomSixResult.count < 6 {
            guard let element = Assets.allCases.randomElement() else {
                completion(.failure(ServiceError.randomResultNotExists))
                return
            }
            randomSixResult.update(with: element)
        }
        let result = randomSixResult.map{ $0.string() }
        completion(.success(result))
    }
}
