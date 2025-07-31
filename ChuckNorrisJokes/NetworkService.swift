//
//  NetworkService.swift
//  ChuckNorrisJokes
//
//  Created by Razumov Pavel on 30.07.2025.
//

import Foundation

struct Joke: Codable {
    let id: String
    let value: String
    let categories: [String]
}

final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private let baseUrlString = "https://api.chucknorris.io/jokes"
    
    func fetchRandomJoke() async throws -> Joke {
        guard let url = URL(string: "\(baseUrlString)/random") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let joke = try JSONDecoder().decode(Joke.self, from: data)
        return joke
    }
}
