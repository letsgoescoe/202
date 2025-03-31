//
//  ContentView.swift
//  hamza
//
//  Created by Dominique Escoe on 3/12/25.
//

import SwiftUI
import Foundation

// Story Model (remains the same as in previous implementation)
struct Story: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var lastEdited: Date
    
    init(id: UUID = UUID(), title: String = "Untitled Story", content: String = "") {
        self.id = id
        self.title = title
        self.content = content
        self.lastEdited = Date()
    }
}

// Color Extension for Custom Colors
extension Color {
    static let customBackground = Color(hex: "FAF7F0")
    static let customSidebar = Color(hex: "FAF7F0")
    static let customMainBackground = Color(hex: "D8D8D8")
    static let customBlue = Color(hex: "7798AB")
    
    // Hex color initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// StorageManager (remains the same as in previous implementation)
class StorageManager: ObservableObject {
    @Published var stories: [Story] = []
    private let storiesKey = "SavedStories"
    
    init() {
        loadStories()
    }
    
    func loadStories() {
        if let data = UserDefaults.standard.data(forKey: storiesKey),
           let decodedStories = try? JSONDecoder().decode([Story].self, from: data) {
            stories = decodedStories.sorted { $0.lastEdited > $1.lastEdited }
        }
    }
    
    func saveStories() {
        if let encoded = try? JSONEncoder().encode(stories) {
            UserDefaults.standard.set(encoded, forKey: storiesKey)
        }
    }
    
    func addStory(_ story: Story) {
        stories.insert(story, at: 0)
        saveStories()
    }
    
    func updateStory(_ story: Story) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index] = story
            stories.sort { $0.lastEdited > $1.lastEdited }
            saveStories()
        }
    }
    
    func deleteStory(_ story: Story) {
        stories.removeAll { $0.id == story.id }
        saveStories()
    }
}

// Sidebar View
struct SidebarView: View {
    @Binding var isExpanded: Bool
    @ObservedObject var storageManager: StorageManager
    @Binding var selectedStory: Story?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: "house")
                        .foregroundColor(.black)
                        .padding()
                }
                
                if isExpanded {
                    Text("Recents")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            
            List {
                ForEach(storageManager.stories) { story in
                    Button(action: {
                        selectedStory = story
                    }) {
                        HStack {
                            Text(story.title)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            Spacer()
                            Text(story.lastEdited, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteStories)
            }
            
            Spacer()
            
            Button(action: {
                let newStory = Story()
                storageManager.addStory(newStory)
                selectedStory = newStory
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                    if isExpanded {
                        Text("New Story")
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
        }
        .background(Color.customSidebar)
        .frame(width: isExpanded ? 250 : 70)
        .animation(.default, value: isExpanded)
    }
    
    private func deleteStories(at offsets: IndexSet) {
        offsets.forEach { index in
            storageManager.deleteStory(storageManager.stories[index])
        }
    }
}

// Story Preview View
struct StoryPreviewView: View {
    let story: Story
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Story Title")
                .font(.headline)
                .foregroundColor(.black)
            
            Text(story.content)
                .font(.body)
                .foregroundColor(.black)
                .lineLimit(5)
                .truncationMode(.tail)
        }
        .padding()
        .background(Color.customBackground)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct StoryEditorView: View {
    @Binding var story: Story
    @ObservedObject var storageManager: StorageManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Story Title
            TextField("Story Title", text: Binding(
                get: { story.title },
                set: { newValue in
                    story.title = newValue
                    story.lastEdited = Date()
                    storageManager.updateStory(story)
                }
            ))
            .font(.title)
            .padding()
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(8)
            
            // Text Editor (Writing Board)
            TextEditor(text: Binding(
                get: { story.content },
                set: { newValue in
                    story.content = newValue
                    story.lastEdited = Date()
                    storageManager.updateStory(story)
                }
            ))
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(8)
            .frame(maxHeight: .infinity)
            
            // Save Button Below Editor
            Button(action: {
                storageManager.updateStory(story)
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.customBlue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}


// Main Content View
struct ContentView: View {
    @State private var isExpanded = true
    @StateObject private var storageManager = StorageManager()
    @State private var selectedStory: Story?
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Title Bar
                HStack {
                    Spacer()
                    Text("Story Builder")
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.customBlue)
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    // Sidebar
                    SidebarView(
                        isExpanded: $isExpanded,
                        storageManager: storageManager,
                        selectedStory: $selectedStory
                    )
                    
                    // Main Content Area
                    ZStack {
                        Color.customMainBackground
                        
                        if let story = selectedStory {
                            HStack {
                                // Story Editor
                                StoryEditorView(
                                    story: Binding(
                                        get: { story },
                                        set: { storageManager.updateStory($0) }
                                    ),
                                    storageManager: storageManager
                                )
                                .background(Color.customMainBackground)
                                
                                // Story Preview
                                StoryPreviewView(story: story)
                                    .frame(width: 550)
                                    .padding()
                            }
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
