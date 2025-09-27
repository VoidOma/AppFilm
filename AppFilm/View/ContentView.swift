// DOSSIER VUE/ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject private var animeViewModel = AnimeViewModel()
    // 💡 Crée l'instance unique
    @StateObject private var filmViewModel = FilmViewModel()
    
    var body: some View {
        TabView {
            // ... (Vos onglets Anime) ...
            
            // -------------------- ONGLETS FILMS --------------------
            
            NavigationView {
                FilmListView(title: "Nouveaux Films",
                             films: filmViewModel.addedFilms,
                             onStatusChange: filmViewModel.updateStatus)
            }
            .tabItem { Label("Nouveaux", systemImage: "plus.circle.fill") }

            NavigationView {
                FilmListView(title: "Watchlist Films",
                             films: filmViewModel.wishlistFilms,
                             onStatusChange: filmViewModel.updateStatus)
            }
            .tabItem { Label("Watchlist", systemImage: "star.fill") }
            
            // 💡 CORRIGÉ : Passage de l'argument 'viewModel'
            NavigationView {
                AddFilmView(viewModel: filmViewModel)
            }
            .tabItem { Label("Ajouter", systemImage: "film") }
        }
    }
}
