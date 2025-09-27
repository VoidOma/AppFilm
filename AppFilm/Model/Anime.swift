//
//  Anime.swift
//  AppFilm
//
//  Created by admin on 26/09/2025.
//

import Foundation

enum AnimeStatus: String, Codable {
    case unwatched
    case wishlist
    case completed
}

struct Anime: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let imageURL: String?
    var status: AnimeStatus
}
