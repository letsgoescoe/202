
//
//  ContentView.swift
//  Challenge 6
//
//  Created by Justyn Paige on 3/24/25.
//

import SwiftUI

struct ContentView1: View {
    @State private var text: String = ""

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    // Writing Prompt Field
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color.blue)
                        .shadow(radius: 10)
                        .frame(width: 400, height: 100)
                        .overlay(
                            TextField("Writing Prompt", text: $text, axis: .vertical)
                                .padding()
                                .foregroundStyle(.black)
                                .frame(width: 350)
                        )

                    // Buttons Row
                    HStack(spacing: 30) {
                        // Auto Generate Button
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.blue)
                            .shadow(radius: 10)
                            .frame(width: 150, height: 50)
                            .overlay(
                                Text("Auto Generate")
                                    .foregroundStyle(.black)
                            )

                        // Previous Boards Button
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.blue)
                            .shadow(radius: 10)
                            .frame(width: 150, height: 50)
                            .overlay(
                                Text("Previous Boards")
                                    .foregroundStyle(.black)
                            )
                    }
                }
                .navigationTitle("Lit List")
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            print("Tool")
                        }) {
                            Image(systemName: "person.circle.fill")
                                .padding()
                        }
                    }
                }
            }
        }
    }
}



#Preview {
    ContentView1()
}
