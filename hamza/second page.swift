//
//  second page.swift
//  hamza
//
//  Created by Dominique Escoe on 3/31/25.
//

//
//  ContentView.swift
//  ThinkingAppMacOS
//
//  Created by Yousef Alsharafi on 3/25/25.
//

import SwiftUI

// MARK: - Text Item Model
struct TextItem: Identifiable {
    let id = UUID()
    var text: String
    var position: CGPoint
    var color: Color
}

// MARK: - Main Content View
struct ContentView3: View {
    @State private var selectedColor: Color = .black
    @State private var isTextEditing: Bool = false

    var body: some View {
        HStack(spacing: 0) {
            SidebarView2(selectedColor: $selectedColor, isTextEditing: $isTextEditing)
            MainWhiteboardView(selectedColor: $selectedColor, isTextEditing: $isTextEditing)
        }
        .frame(minWidth: 800, minHeight: 500)
    }
}



#Preview {
    ContentView3()
}

// MARK: - Main Whiteboard View
struct MainWhiteboardView: View {
    @State private var boardTitle: String = "White Board"
    @Binding var selectedColor: Color
    @Binding var isTextEditing: Bool
    @State private var textItems: [TextItem] = []

    var body: some View {
        VStack {
            TextField("Enter title...", text: $boardTitle)
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.5))
                .cornerRadius(10)
                .padding(5)
                .multilineTextAlignment(.center)
                .textFieldStyle(PlainTextFieldStyle())

            ZStack {
                Color.blue.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture { location in
                        if isTextEditing {
                            textItems.append(TextItem(text: "", position: location, color: selectedColor))
                            isTextEditing = false
                        }
                    }

                ForEach($textItems) { $item in
                    DraggableTextField(item: $item)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(10)
            .padding(5)
        }
        .background(Color.white)
    }
}

// MARK: - Draggable Text Field
struct DraggableTextField: View {
    @Binding var item: TextItem
    @State private var offset: CGSize = .zero
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Write here...", text: $item.text)
            .font(.title2)
            .foregroundColor(item.color)
            .padding(8)
            .background(Color.white.opacity(0.8))
            .cornerRadius(5)
            .frame(width: 200)
            .position(item.position)
            .focused($isFocused)
            .onChange(of: isFocused) { focused in
                if !focused && item.text.isEmpty {
                    item.text = "Write here..."
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        item.position = CGPoint(
                            x: item.position.x + gesture.translation.width,
                            y: item.position.y + gesture.translation.height
                        )
                    }
            )
    }
}

// MARK: - Sidebar View
struct SidebarView2: View {
    @Binding var selectedColor: Color
    @Binding var isTextEditing: Bool
    let colors: [Color] = [.black, .purple, .red, .green, .white, .blue, .yellow]

    var body: some View {
        VStack {
            Button(action: {
                isTextEditing.toggle()
            }) {
                HStack {
                    Image(systemName: "textformat")
                    Text("Text")
                        .font(.caption)
                        .bold()
                }
                .padding(12)
                .background(isTextEditing ? Color.blue.opacity(0.5) : Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())

            VStack(spacing: 10) {
                ForEach(colors, id: \ .self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(selectedColor == color ? Color.white : Color.clear, lineWidth: 4)
                        )
                        .shadow(color: selectedColor == color ? .black.opacity(0.3) : .clear, radius: 3)
                        .onTapGesture {
                            selectedColor = color
                        }
                }
            }
            .frame(width: 60)
            .padding(.vertical)
            .background(Color.gray.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 15))

            Spacer()
        }
        .frame(width: 100)
        .background(Color.gray.opacity(0.3))
    }
}


