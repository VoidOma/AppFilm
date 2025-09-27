// Fichier : FilmListView.swift (Vue réutilisable)

import SwiftUI

struct FilmListView: View {
    let title: String
    let films: [Film]
    let onStatusChange: (Film, FilmStatus) -> Void
    
    var body: some View {
        List(films) { film in
            HStack {
                VStack(alignment: .leading) {
                    Text(film.titre)
                        .font(.headline)
                    Text("Genre: \(film.genre ?? "N/A") - Réal.: \(film.realisateur ?? "N/A")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 💡 Bouton Watchlist
                if film.status != .wishlist {
                    Button("🎯 Watchlist") {
                        onStatusChange(film, .wishlist)
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("En Watchlist")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle(title)
        // 💡 Fonctionnalité : Swipe pour marquer comme vu
        .swipeActions {
            Button("Vu") {
                onStatusChange(film, .watched)
            }
            .tint(.green)
        }
    }
}