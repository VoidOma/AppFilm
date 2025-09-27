//
//  ContentView.swift
//  AppFilm
//
//  Created by admin on 26/09/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AnimeViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                AnimeListView(title: "Non regardés",
                              animes: viewModel.unwatched,
                              onStatusChange: viewModel.updateStatus)
            }
            .tabItem { Label("Unwatched", systemImage: "eye") }
            
            NavigationView {
                AnimeListView(title: "Wishlist",
                              animes: viewModel.wishlist,
                              onStatusChange: viewModel.updateStatus)
            }
            .tabItem { Label("Wishlist", systemImage: "star") }
            
            NavigationView {
                AnimeListView(title: "Terminés",
                              animes: viewModel.completed,
                              onStatusChange: viewModel.updateStatus)
            }
            .tabItem { Label("Completed", systemImage: "checkmark") }
            
            NavigationView {
                AddFilmView()
            }
            .tabItem { Label("Films", systemImage: "film") }
        
        }
    }
}
