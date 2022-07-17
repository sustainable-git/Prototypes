//
//  SandboxView.swift
//  SpotLight
//
//  Created by Shin Jae Ung on 2022/04/19.
//

import SwiftUI
import Combine

struct SandboxView: View {
    @State var string: String = ""
    
    var body: some View {
        VStack {
            if string.isEmpty {
                Spacer()
                    .frame(width: 0, height: 110)
            } else {
                BrailleContentView(string, showNext: .constant(false))
            }
                
            TextField("Type here within 10 letters", text: self.$string)
                .onReceive(Just(string)) { _ in limitText(10) }
                .padding()
                .overlay(Capsule().stroke())
                .padding(.horizontal, 100)
        }
    }
    
    func limitText(_ limit: Int) {
        self.string = string.lowercased()
        if self.string.count > limit {
            self.string = String(self.string.prefix(limit))
        }
    }
}

struct SandboxView_Preview: PreviewProvider {
    static var previews: some View {
        SandboxView()
    }
}
