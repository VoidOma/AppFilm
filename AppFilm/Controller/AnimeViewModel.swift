//
//  AnimeViewModel.swift
//  AppFilm
//
//  Created by admin on 26/09/2025.
//

import Foundation

@MainActor
class AnimeViewModel: ObservableObject {
    @Published var animes: [Anime] = []
    private let service = JikanService()
    
    init() {
        load()
        Task {
            await fetchAnimesOfToday()
        }
    }
    
    func fetchAnimesOfToday() {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        dayFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dayString = dayFormatter.string(from: Date()).lowercased()
        
        Task {
            do {
                let fetchedAnimes = try await service.fetchAllSchedules(for: dayString)
                for anime in fetchedAnimes {
                    if !self.animes.contains(where: { $0.id == anime.id }) {
                        self.animes.append(anime)
                    }
                }
                self.save()
            } catch {
                print("Erreur API:", error)
            }
        }
    }
    
    func updateStatus(for anime: Anime, status: AnimeStatus) {
        if let index = animes.firstIndex(where: { $0.id == anime.id }) {
            animes[index].status = status
            save()
        }
    }
    
    // MARK: - Persistance simple
    private func save() {
        if let encoded = try? JSONEncoder().encode(animes) {
            UserDefaults.standard.set(encoded, forKey: "animes")
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "animes"),
           let decoded = try? JSONDecoder().decode([Anime].self, from: data) {
            animes = decoded
        }
    }
    
    var unwatched: [Anime] { animes.filter { $0.status == .unwatched } }
    var wishlist: [Anime] { animes.filter { $0.status == .wishlist } }
    var completed: [Anime] { animes.filter { $0.status == .completed } }
}
