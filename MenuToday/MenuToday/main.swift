//
//  main.swift
//  MenuToday
//
//  Created by Shin Jae Ung on 2022/03/18.
//

import Foundation

let baseURL = "https://food.podac.poapper.com/v1/menus/"
var formatter = DateFormatter()
formatter.dateFormat = "yyyy/MM/dd"
let today = formatter.string(from: Date())

func menuToday(completion: @escaping () -> ()) {
    fetchURL(baseURL + today) { result in
        switch result {
        case .success(let menu):
            print("오늘의 학생식당 메뉴! (\(today))\n")
            print(menu)
            completion()
        case .failure(let error):
            print(error)
        }
    }
    _ = readLine()!
}

menuToday {
    print("\n종료하려면 Enter 키를 눌러주세요!")
}
