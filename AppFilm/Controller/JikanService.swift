//
//  JikanService.swift
//  AppFilm
//
//  Created by admin on 26/09/2025.
//

import Foundation

struct PaginatedScheduleResponse: Codable {
    let data: [APIAnime]
    let pagination: Pagination
}

struct Pagination: Codable {
    let last_visible_page: Int
    let has_next_page: Bool
    let current_page: Int
}

struct APIAnime: Codable {
    let id: Int
    let title: String
    let images: Images?
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case title
        case images
    }
}

struct Images: Codable {
    let jpg: JPG
}

struct JPG: Codable {
    let image_url: String
}

@MainActor
class JikanService {
    private let baseURL = "https://api.jikan.moe/v4/schedules"
    
    /// Récupère tous les animes pour un jour donné avec pagination
    func fetchAllSchedules(for day: String) async throws -> [Anime] {
        var allAnimes: [Anime] = []
        var currentPage = 1
        var hasNextPage = true
        
        while hasNextPage {
            let urlString = "\(baseURL)?filter=\(day)&page=\(currentPage)&limit=25"
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(PaginatedScheduleResponse.self, from: data)
            
            let animes = response.data.map {
                Anime(
                    id: $0.id,
                    title: $0.title,
                    imageURL: $0.images?.jpg.image_url,
                    status: .unwatched // 🔥 défaut obligatoire
                )
            }
            
            allAnimes.append(contentsOf: animes)
            hasNextPage = response.pagination.has_next_page
            currentPage += 1
        }
        
        return allAnimes
    }
}
