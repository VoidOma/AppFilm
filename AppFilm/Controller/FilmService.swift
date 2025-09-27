// DOSSIER MODEL/Film.swift

import Foundation

enum FilmStatus: String, Codable {
    case added
    case wishlist
    case watched
}

struct Film: Codable, Identifiable, Equatable {
    // L'ID est essentiel pour le décodage Vapor et pour SwiftUI.
    var id: UUID?
    
    var titre: String
    var genre: String?
    var duree: Int?
    var dateSortie: String?
    var prix: Double
    var realisateur: String?
    
    // Statut local par défaut
    var status: FilmStatus = .added

    enum CodingKeys: String, CodingKey {
        case id
        case titre
        case genre
        case duree
        case dateSortie = "date_sortie"
        case prix
        case realisateur
    }
}

// DOSSIER SERVICE/FilmService.swift

import Foundation

final class FilmService: Sendable {
    // 💡 Vérifiez que cette URL est correcte (localhost pour le simulateur)
    private let baseURL = "http://localhost:8080/api/films"

    /// Récupère tous les films de l'API Vapor (GET)
    func fetchFilms() async throws -> [Film] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        // Le décodage lancera l'erreur standard si le JSON n'est pas bon
        return try JSONDecoder().decode([Film].self, from: data)
    }

    /// Ajoute un film à l'API Vapor (POST)
    func addFilm(_ film: Film) async throws -> Film {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(film)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        // Retourne le film créé (avec l'ID généré par Vapor)
        return try JSONDecoder().decode(Film.self, from: data)
    }
}
