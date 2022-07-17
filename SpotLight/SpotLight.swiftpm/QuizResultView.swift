//
//  QuizResultView.swift
//  SpotLight
//
//  Created by Shin Jae Ung on 2022/04/19.
//

import SwiftUI

struct QuizResultView: View {
    @Binding var showQuiz: Bool
    let score: Int
    var body: some View {
        VStack {
            Text("Your score: \(String(score)) / 15")
                .font(.largeTitle)
            Button {
                self.showQuiz = false
            } label: {
                Text("Go back to guide page")
                    .padding()
            }
            .buttonStyle(.bordered)
        }
    }
}

struct QuizResultView_Preview: PreviewProvider {
    static var previews: some View {
        QuizResultView(showQuiz: .constant(true), score: 14)
    }
}
