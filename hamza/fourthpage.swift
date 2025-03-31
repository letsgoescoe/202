import SwiftUI

struct DraftScreenView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        NavigationLink(destination: ContentView1()) {
                            Image(systemName: "house")
                                .imageScale(.large)
                                .foregroundStyle(Color.black)
                        }
                        .offset(x: 400)

                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.blue)
                                .frame(width: 300, height: 50)
                                .shadow(radius: 5)
                            Text("Drafts")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        }
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.gray)
                            .frame(width: 150, height: 300)
                            .offset(x: -220)
                        Button(action: {
                            print("1. Whiteboard button tapped!")
                        }) {
                            Text("1. Whiteboard")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        .offset(x: -220, y: -100)
                    }

                    HStack {
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.secondary)
                            .frame(width: 400, height: 300)
                            .offset(x: 80, y: -325)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    DraftScreenView()
}

