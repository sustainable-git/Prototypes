//
//  GuideView.swift
//  SpotLight
//
//  Created by Shin Jae Ung on 2022/04/19.
//

import SwiftUI

struct GuideView: View {
    @State private var showQuiz: Bool = false
    @State private var showSandbox: Bool = false
    @State private var orientation: UIDeviceOrientation = UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? .portrait : .landscapeLeft
    var body: some View {
        NavigationView {
            if self.orientation.isLandscape || self.orientation.isFlat {
                VStack {
                    HStack(spacing: 0) {
                        ForEach("abcdefghijklmn".map{ $0 }, id: \.self) { string in
                            GuideBrailleView(string)
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach("opqrstuvwxyz".map{ $0 }, id: \.self) { string in
                            GuideBrailleView(string)
                        }
                    }
                    HStack {
                        NavigationLink(isActive: self.$showQuiz) {
                            QuizView(showQuiz: self.$showQuiz, quiz: quiz, pageIndex: 0, score: 0)
                        } label: {
                            Spacer().frame(width: 0, height: 0)
                        }
                        BrailleContentView("quiz", showNext: self.$showQuiz)
                        Spacer()
                        NavigationLink(isActive: self.$showSandbox) {
                            SandboxView()
                        } label: {
                            Spacer().frame(width: 0, height: 0)
                        }
                        BrailleContentView("sandbox", showNext: self.$showSandbox)
                    }
                    .padding(.horizontal, 100)
                    .padding(.vertical, 50)
                }
            } else {
                VStack {
                    HStack(spacing: 0) {
                        ForEach("abcdefg".map{ $0 }, id: \.self) { string in
                            GuideBrailleView(string)
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach("hijklmn".map{ $0 }, id: \.self) { string in
                            GuideBrailleView(string)
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach("opqrstu".map{ $0 }, id: \.self) { string in
                            GuideBrailleView(string)
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach("vwxyz".map{ $0 }, id: \.self) { string in
                            GuideBrailleView(string)
                        }
                    }
                    HStack {
                        NavigationLink(isActive: self.$showQuiz) {
                            QuizView(showQuiz: self.$showQuiz, quiz: quiz, pageIndex: 0, score: 0)
                        } label: {
                            Spacer().frame(width: 0, height: 0)
                        }
                        BrailleContentView("quiz", showNext: self.$showQuiz)
                        Spacer()
                        NavigationLink(isActive: self.$showSandbox) {
                            SandboxView()
                        } label: {
                            Spacer().frame(width: 0, height: 0)
                        }
                        BrailleContentView("sandbox", showNext: self.$showSandbox)
                    }
                    .padding(.horizontal, 100)
                    .padding(.vertical, 50)
                }
            }
        }
        .navigationTitle("Guide Page")
        .navigationBarHidden(false)
        .onRotate { newValue in
            self.orientation = newValue
        }
    }
}

struct GuideBrailleView: View {
    private let string: String
    
    init(_ character: Character) {
        self.string = character.lowercased()
    }
    
    var body: some View {
        VStack {
            BrailleContentView(string, showNext: .constant(false))
            Text(String(string))
                .font(.largeTitle)
        }
    }
}

struct DeviceRotationViewModifier: ViewModifier {
    let closure: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                self.closure(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform closure: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(closure: closure))
    }
}

struct GuideView_Preview: PreviewProvider {
    static var previews: some View {
        GuideView()
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct GuideBrailleView_Preview: PreviewProvider {
    static var previews: some View {
        GuideBrailleView("j")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
