//
//  AnimListView.swift
//  AppFilm
//
//  Created by admin on 26/09/2025.
//

import SwiftUI

struct AnimeListView: View {
    let title: String
    let animes: [Anime]
    let onStatusChange: (Anime, AnimeStatus) -> Void
    
    var body: some View {
        List(animes) { anime in
            HStack {
                if let imageURL = anime.imageURL,
                   let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 70)
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Text(anime.title)
                        .font(.headline)
                    
                    HStack {
                        Button("🎯 Wishlist") {
                            onStatusChange(anime, .wishlist)
                        }
                        .buttonStyle(.bordered)
                        
                        Button("✅ Terminé") {
                            onStatusChange(anime, .completed)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
        .navigationTitle(title)
    }
}
