//
//  Recipe.swift
//  MyCuisineData
//
//  Created by sokolli on 10/19/24.
//

import Foundation

/// A struct representing a recipe, it contains various properties describing the recipe,
/// including its cuisine, name, associated URLs for images and sources, and a unique identifier.
/// CodingKeys are used to map the JSON keys to the struct properties for decoding purposes,
/// ensuring compatibility with the external API format.

struct Recipe: Codable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: String
    let sourceUrl: String?
    let youtubeUrl: String?

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case uuid
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
