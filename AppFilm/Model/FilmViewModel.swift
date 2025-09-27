// DOSSIER CONTROLLER/FilmViewModel.swift

import Foundation

@MainActor
class FilmViewModel: ObservableObject {
    // Propriétés du formulaire
    @Published var titre: String = ""
    @Published var genre: String = ""
    @Published var duree: String = ""
    @Published var dateSortie: String = ""
    @Published var prix: String = ""
    @Published var realisateur: String = ""
    @Published var statusMessage: String = ""
    
    // Liste des films et services
    @Published var allFilms: [Film] = []
    private let service = FilmService()
    
    init() {
        Task {
            await fetchFilms()
        }
    }
    
    // MARK: - Récupération et Gestion de Liste
    
    func fetchFilms() async {
        do {
            let fetchedFilms = try await service.fetchFilms()
            
            // Logique de fusion : mettre à jour les films existants ou ajouter les nouveaux.
            for newFilm in fetchedFilms {
                if let index = allFilms.firstIndex(where: { $0.id == newFilm.id }) {
                    // Conserver le statut local (wishlist/watched)
                    let currentStatus = allFilms[index].status
                    allFilms[index] = newFilm
                    allFilms[index].status = currentStatus
                } else {
                    allFilms.append(newFilm)
                }
            }
        } catch {
            print("Erreur de récupération des films:", error.localizedDescription)
        }
    }
    
    func updateStatus(for film: Film, status: FilmStatus) {
        if let index = allFilms.firstIndex(where: { $0.id == film.id }) {
            allFilms[index].status = status
        }
    }
    
    // MARK: - Ajout de Film
    
    func addFilm() async {
        guard let prixDouble = Double(prix) else {
            statusMessage = "❌ Prix invalide"
            return
        }
        
        let film = Film(
            id: nil,
            titre: titre,
            genre: genre.isEmpty ? nil : genre,
            duree: Int(duree),
            dateSortie: dateSortie.isEmpty ? nil : dateSortie,
            prix: prixDouble,
            realisateur: realisateur.isEmpty ? nil : realisateur
        )
        
        do {
            let createdFilm = try await service.addFilm(film)
            statusMessage = "✅ Film ajouté : \(createdFilm.titre)"
            clearForm()
            await fetchFilms() // Recharger la liste pour afficher le nouveau film
        } catch {
            statusMessage = "❌ Erreur: \(error.localizedDescription)"
        }
    }
    
    private func clearForm() {
        titre = ""; genre = ""; duree = ""; dateSortie = ""; prix = ""; realisateur = ""
    }
    
    var addedFilms: [Film] { allFilms.filter { $0.status == .added } }
    var wishlistFilms: [Film] { allFilms.filter { $0.status == .wishlist } }
    var watchedFilms: [Film] { allFilms.filter { $0.status == .watched } }
}
