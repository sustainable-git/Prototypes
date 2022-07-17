//
//  BrailleContentView.swift
//  SpotLight
//
//  Created by Shin Jae Ung on 2022/04/18.
//

import SwiftUI
import AVFAudio

struct BrailleContentView: View {
    @Binding internal var showNext: Bool
    @State private var isTouched: [Bool]
    private var texts: [Character]
    private let haptic: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let synthesizer = AVSpeechSynthesizer()
    
    
    init(_ string: String, showNext: Binding<Bool>) {
        self.texts = string.map{ Character(extendedGraphemeClusterLiteral: $0) }
        self.isTouched = Array(repeating: false, count: string.count)
        self.haptic.prepare()
        self._showNext = showNext
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<self.texts.count, id: \.self) { index in
                let character = self.texts[index]
                if self.isTouched.count == self.texts.count, isTouched[index] {
                    BrailleView(character, isTouched: true)
                } else {
                    BrailleView(character, isTouched: false)
                }
                
            }
        }
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                let xLocation = value.location.x / 70
                let yLocation = value.location.y / 110
                guard 0..<CGFloat(self.texts.count) ~= xLocation,
                      0..<1 ~= yLocation
                      else { return }
                let index = Int(xLocation)
                if self.isTouched.count == self.texts.count, !self.isTouched[index] {
                    self.isTouched[index] = true
                    self.haptic.impactOccurred()
                    
                    self.synthesizer.stopSpeaking(at: .immediate)
                    let utterance = AVSpeechUtterance(string: String(self.texts[index]))
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    self.synthesizer.speak(utterance)
                }
            })
            .onEnded({ _ in
                if self.isTouched.allSatisfy({ $0 == true }) {
                    self.showNext = true
                    
                    if self.texts.count > 1 {
                        self.synthesizer.stopSpeaking(at: .immediate)
                        let utterance = AVSpeechUtterance(string: texts.map{ String($0) }.joined())
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                        self.synthesizer.speak(utterance)
                    }
                }
                self.isTouched = Array(repeating: false, count: self.texts.count)
            })
        )
    }
}

struct BreilleContentView_Preview: PreviewProvider {
    static var previews: some View {
        BrailleContentView("spotlight", showNext: .constant(false))
        BrailleContentView("spotlight", showNext: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
        BrailleContentView("spotlight", showNext: .constant(false))
            .previewInterfaceOrientation(.landscapeLeft)
            .preferredColorScheme(.dark)
    }
}
