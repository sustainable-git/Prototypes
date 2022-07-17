//
//  QuizView.swift
//  SpotLight
//
//  Created by Shin Jae Ung on 2022/04/19.
//

import SwiftUI

struct QuizView: View {
    @Binding var showQuiz: Bool
    let quiz: Quiz
    let pageIndex: Int
    let score: Int

    var body: some View {
        VStack {
            BrailleContentView(self.quiz[self.pageIndex].text, showNext: .constant(false))
                .padding(.vertical)
            Spacer()
            ForEach(0..<self.quiz[self.pageIndex].choices.count, id: \.self) { index in
                NavigationLink {
                    if self.quiz[pageIndex].choices[index].isCorrect {
                        if self.pageIndex == self.quiz.pages.count - 1 {
                            QuizResultView(showQuiz: self.$showQuiz, score: self.score + self.pageIndex + 1)
                        } else {
                            QuizView(showQuiz: self.$showQuiz, quiz: self.quiz, pageIndex: self.pageIndex + 1, score: self.score + self.pageIndex + 1)
                        }
                    } else {
                        if self.pageIndex == self.quiz.pages.count - 1 {
                            QuizResultView(showQuiz: self.$showQuiz, score: self.score)
                        } else {
                            QuizView(showQuiz: self.$showQuiz, quiz: self.quiz, pageIndex: self.pageIndex + 1, score: self.score)
                        }
                    }
                } label: {
                    Text(quiz[self.pageIndex].choices[index].text)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.25))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .navigationTitle("Page : \(self.pageIndex + 1) / 5")
        .navigationViewStyle(.stack)
    }
}

struct QuizView_Preview: PreviewProvider {
    static var previews: some View {
        QuizView(showQuiz: .constant(true), quiz: quiz, pageIndex: 0, score: 0)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
