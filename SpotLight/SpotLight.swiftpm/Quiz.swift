//
//  Quiz.swift
//  SpotLight
//
//  Created by Shin Jae Ung on 2022/04/19.
//

import Foundation

struct Quiz {
    let pages: [QuizPage]
    
    subscript(_ pageIndex: Int) -> QuizPage {
        return pages[pageIndex]
    }
}

struct QuizPage {
    let text: String
    let choices: [Choice]
    
    init(_ text: String, choices: [Choice]) {
        self.text = text
        self.choices = choices
    }
}

struct Choice {
    let text: String
    let isCorrect: Bool
}

let quiz = Quiz(
    pages: [
        QuizPage(
            "cat",
            choices: [
                Choice(
                    text: "new",
                    isCorrect: false
                ),
                Choice(
                    text: "cat",
                    isCorrect: true
                ),
                Choice(
                    text: "dog",
                    isCorrect: false
                )
            ]
        ),
        QuizPage(
            "coke",
            choices: [
                Choice(
                    text: "coke",
                    isCorrect: true
                ),
                Choice(
                    text: "fish",
                    isCorrect: false
                ),
                Choice(
                    text: "hair",
                    isCorrect: false
                )
            ]
        ),
        QuizPage(
            "apple",
            choices: [
                Choice(
                    text: "apple",
                    isCorrect: true
                ),
                Choice(
                    text: "fruit",
                    isCorrect: false
                ),
                Choice(
                    text: "arrow",
                    isCorrect: false
                )
            ]
        ),
        QuizPage(
            "street",
            choices: [
                Choice(
                    text: "school",
                    isCorrect: false
                ),
                Choice(
                    text: "choice",
                    isCorrect: false
                ),
                Choice(
                    text: "street",
                    isCorrect: true
                )
            ]
        ),
        QuizPage(
            "braille",
            choices: [
                Choice(
                    text: "largest",
                    isCorrect: false
                ),
                Choice(
                    text: "censors",
                    isCorrect: false
                ),
                Choice(
                    text: "braille",
                    isCorrect: true
                )
            ]
        )
    ]
)
