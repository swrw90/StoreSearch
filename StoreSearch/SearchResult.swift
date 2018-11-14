//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Seth Watson on 10/24/18.
//  Copyright © 2018 Seth Watson. All rights reserved.
//

import Foundation

// Holds a count of results returned from request and array of request objects
class ResultArray:Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

// Lets the Codable protocol know the SearchResult properties should match the JSON data
// Convert JSON to custom object SearchResult
class SearchResult:Codable, CustomStringConvertible {
    var kind: String?
    var artistName = ""
    var trackName: String?
    var trackPrice: Double?
    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }
    
    var name: String {
        return trackName ?? collectionName ?? ""
    }
    
    var storeURL: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    
    var price: Double {
        return trackPrice ?? collectionPrice ?? 0.0
    }
    
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    
    // Returns string matching with the JSON type
    var type: String {
        let kind = self.kind ?? "audiobook"
        switch kind {
        case "album": return NSLocalizedString("Album", comment: "Localized Kind: Album")
        case "audiobook": return NSLocalizedString("Audio Book", comment: "Localized Kind: Audio Book")
        case "book": return NSLocalizedString("Book", comment: "Localized Kind: Book")
        case "ebook": return NSLocalizedString("E-Book", comment: "Localized Kind: E-Book")
        case "feature-movie": return NSLocalizedString("Movie", comment: "Localized Kind: Movie")
        case "music-video": return NSLocalizedString("Music Video", comment: "Localized Kind: Music Video")
        case "podcast": return NSLocalizedString("Podcast", comment: "Localized Kind: Podcast")
        case "software": return NSLocalizedString("App", comment: "Localized Kind: App")
        case "song": return NSLocalizedString("Song", comment: "Localized Kind: Song")
        case "tv-episode": return NSLocalizedString("TV Episode", comment: "Localized Kind: TV Episode")
        default:
            return kind
        }
    }
    
    
    var description: String {
        return "Kind: \(kind ?? ""), Name: \(name), Artist Name: \(artistName)\n"
    }
}


// Compare name of two SearchResults in ascending order
func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}

