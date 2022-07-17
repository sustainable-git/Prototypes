//
//  BrailleView.swift
//  SpotLight
//
//  Created by Shin Jae Ung on 2022/04/18.
//

import SwiftUI

struct BrailleView: View {
    private let character: Character
    private let isTouched: Bool
    
    init(_ char: Character, isTouched: Bool) {
        self.character = Character(char.lowercased())
        self.isTouched = isTouched
    }
    
    var body: some View {
        let diameter: CGFloat = 15
        let space: CGFloat = 10
        let horizontalPadding: CGFloat = 30
        let verticalPadding: CGFloat = 45
        
        ZStack {
            VStack(alignment: .center) {
                HStack {
                    Circle()
                        .frame(width: diameter, height: diameter)
                        .foregroundColor(Color("braille"))
                        .opacity("abcdefghklmnopqruvxyz".contains(where: {$0 == character}) ? 1 : 0)
                    Spacer()
                        .frame(width: space, height: 0)
                    Circle()
                        .frame(width: diameter, height: diameter)
                        .foregroundColor(Color("braille"))
                        .opacity("cdfgijmnpqstwxy".contains(where: {$0 == character}) ? 1 : 0)
                }
                Spacer()
                    .frame(width: 0, height: space)
                HStack {
                    Circle()
                        .frame(width: diameter, height: diameter)
                        .foregroundColor(Color("braille"))
                        .opacity("bfghijlpqrstvw".contains(where: {$0 == character}) ? 1 : 0)
                    Spacer()
                        .frame(width: space, height: 0)
                    Circle()
                        .frame(width: diameter, height: diameter)
                        .foregroundColor(Color("braille"))
                        .opacity("deghjnoqrtwyz".contains(where: {$0 == character}) ? 1 : 0)
                }
                Spacer()
                    .frame(width: 0, height: space)
                HStack {
                    Circle()
                        .frame(width: diameter, height: diameter)
                        .foregroundColor(Color("braille"))
                        .opacity("klmnopqrstuvxyz".contains(where: {$0 == character}) ? 1 : 0)
                    Spacer()
                        .frame(width: space, height: 0)
                    Circle()
                        .frame(width: diameter, height: diameter)
                        .foregroundColor(Color("braille"))
                        .opacity("uvwxyz".contains(where: {$0 == character}) ? 1 : 0)
                }
            }
            .background(.clear)
            .padding(.horizontal, horizontalPadding/2)
            .padding(.vertical, verticalPadding/2)
            .opacity(isTouched ? 0.2 : 1)
            if isTouched {
                withAnimation {
                    ZStack{
                        Circle()
                            .stroke()
                            .foregroundColor(Color("label"))
                            .frame(width: 60, height: 60)
                        Text(String(character))
                            .font(.largeTitle)
                            .foregroundColor(Color("label"))
                    }
                }
            }
        }
    }
}


struct BrailleView_Preview: PreviewProvider {
    static var previews: some View {
        BrailleView("R", isTouched: true)
            .previewInterfaceOrientation(.portrait)
            .preferredColorScheme(.light)
        BrailleView("y", isTouched: false)
            .previewInterfaceOrientation(.landscapeLeft)
            .preferredColorScheme(.dark)
    }
}
