// DOSSIER VUE/FilmListView.swift

import SwiftUI

struct FilmListView: View {
    let title: String
    let films: [Film]
    let onStatusChange: (Film, FilmStatus) -> Void
    
    var body: some View {
        List(films) { film in // <-- film est défini ici
            HStack {
                VStack(alignment: .leading) {
                    Text(film.titre).font(.headline)
                    Text("Genre: \(film.genre ?? "N/A") | Prix: \(String(format: "%.2f €", film.prix))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if film.status != .wishlist {
                    Button("🎯 Wishlist") {
                        onStatusChange(film, .wishlist)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .swipeActions {
                // 💡 CORRIGÉ : Utilisation directe de 'film'
                if film.status != .watched {
                    Button("Vu") {
                        onStatusChange(film, .watched)
                    }
                    .tint(.green)
                }
            }
        }
        .navigationTitle(title)
    }
}
