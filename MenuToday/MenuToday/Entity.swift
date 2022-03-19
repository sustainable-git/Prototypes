//
//  Entity.swift
//  MenuToday
//
//  Created by Shin Jae Ung on 2022/03/18.
//

import Foundation

struct Menu: Codable, CustomStringConvertible {
    var description: String {
        return meals.map { $0.description }.joined(separator: "\n")
    }
    let meals: [Meal]
}

struct Meal: Codable, CustomStringConvertible {
    var description: String {
        return (typeDictionary[type] ?? "ERROR") + "\t(\(kcal) kcal, \(protein)g protein)" + "\n\t - " + foods.map{ $0.description }.joined(separator: ", ")
    }
    var typeDictionary: Dictionary<String, String> =
    ["BREAKFAST_A": "학생식당 조식 A",
     "BREAKFAST_B": "학생식당 조식 B",
     "LUNCH": "학생식당 중식",
     "DINNER": "학생식당 석식",
     "STAFF": "위즈덤 중식",
     "INTERNATIONAL": "더 블루힐 중식"]
    let type: String
    let foods: [Food]
    let kcal: Int
    let protein: Int

    enum CodingKeys: String, CodingKey {
        case type
        case foods
        case kcal
        case protein
    }
}

struct Food: Codable, CustomStringConvertible {
    var description: String {
        return "\(korName)"
    }
    
    let korName: String
    let isVegan: Bool
    
    enum CodingKeys: String, CodingKey {
        case korName = "name_kor"
        case isVegan
    }
}
