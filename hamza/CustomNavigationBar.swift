//
//  CustomNavigationBar.swift
//  hamza
//
//  Created by Dominique Escoe on 3/31/25.
//

import SwiftUI

struct AppNavigationBar: View {
    var body: some View {
        HStack {
            NavigationLink(destination: ContentView1()) {
                Label("Home", systemImage: "house")
            }

            Spacer()

            NavigationLink(destination: ContentView3()) {
                Label("Whiteboard", systemImage: "pencil.tip")
            }

            Spacer()

            NavigationLink(destination: DraftScreenView()) {
                Label("Drafts", systemImage: "doc.text")
            }

            Spacer()

            NavigationLink(destination: ContentView()) {
                Label("Prompt", systemImage: "lightbulb")
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
