//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Result: Codable {
    var id: Int
    var isHomeGame: Bool
    var date: String
    var team: String
    var opponent: String
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results: [Result] = []
    
    var body: some View {
        NavigationStack {
            List(results, id: \.id) { item in
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(item.team) vs. \(item.opponent)")
                            .font(.headline)
                        Spacer()
                        Text("\(item.score.unc) - \(item.score.opponent)")
                            .font(.headline)
                    }
                    
                    HStack {
                        Text(item.date)
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        Spacer()
                        Text(item.isHomeGame ? "Home" : "Away")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("UNC Basketball")
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid url")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from: data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid url")
        }
    }
}

#Preview {
    ContentView()
}
