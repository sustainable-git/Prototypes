//
//  HandDragGuideView.swift
//  SpotLight
//
//  Created by Shin Jae Ung on 2022/04/21.
//

import SwiftUI

struct HandDragGuideView: View {
    private let string: String
    private let animation = Animation.easeInOut(duration: 3).repeatForever()
    private var startPosition: CGPoint
    private var endPosition: CGPoint
    @Binding internal var showNext: Bool
    @State private var animationLooper: Bool = true
    
    init(_ string: String, hide: Binding<Bool>) {
        self.string = string.lowercased()
        self.startPosition = CGPoint(x: -string.count * 70 / 2, y: 0)
        self.endPosition = CGPoint(x: (string.count + 1) * 70 / 2, y: 0)
        self._showNext = hide
    }
    
    var body: some View {
        ZStack {
            BrailleContentView(string, showNext: self.$showNext)
            Image(systemName: "hand.tap")
                .font(.system(size: 100))
                .offset(x: 0, y: 50)
                .offset(x: self.animationLooper ? startPosition.x : endPosition.x , y: 0)
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(animation, {
                    self.animationLooper.toggle()
                })
            }
        }
    }
}

struct HandDragGuideView_Preview: PreviewProvider {
    static var previews: some View {
        HandDragGuideView("braille", hide: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
        HandDragGuideView("braille", hide: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
            .preferredColorScheme(.dark)
    }
}
