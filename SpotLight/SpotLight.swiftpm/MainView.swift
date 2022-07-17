import SwiftUI

struct MainView: View {
    @State private var showNext: Bool = false
    @AppStorage("GuideView.showHandDragGuideView") private var showHandDragGuideView = true
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color("background"))
            VStack {
                Text("Spot Light")
                    .foregroundColor(Color("label"))
                    .font(.largeTitle)
                Text("Read braille with your fingers")
                    .foregroundColor(Color("label"))
                    .padding()
                BrailleContentView("spotlight", showNext: self.$showNext)
            }
        }
        .sheet(isPresented: self.$showHandDragGuideView, content: {
            VStack {
                Text("Please play in landscape mode")
                    .foregroundColor(Color("label"))
                    .font(.largeTitle)
                Text("Drag all braille")
                    .foregroundColor(Color("label"))
                    .padding()
                HandDragGuideView("braille", hide: !self.$showHandDragGuideView)
            }
        })
        .fullScreenCover(isPresented: $showNext) {
            GuideView()
        }
    }
}

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
