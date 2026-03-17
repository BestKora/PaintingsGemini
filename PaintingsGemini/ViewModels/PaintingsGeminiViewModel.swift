//
//  PaintingsGeminiViewModel.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 27/12/2025.
//

import SwiftUI

enum PaintingsGeminiLoader {
    static func loadFromBundle() async throws -> [PaintingGemini] {
        try await Task.detached(priority: .userInitiated) {
            guard let url = Bundle.main.url(
                forResource: "PaintingGemini",
                withExtension: "json"
            ) else {
                throw NSError(
                    domain: "PaintingGeminiLoader",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "PaintingsGemini.json not found in Bundle"]
                )
            }

            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([PaintingGemini].self, from: data)
        }.value
    }
}

@Observable @MainActor
final class PaintingsGeminiViewModel {
    var paintings: [PaintingGemini] = []
    var selectedArtist: String = ""
    var artists: [String] {
        Array(Set(paintings.map { $0.artist }))
    }
    var artistItems: [ArtistItem] {
        paintings.reduce(into: [:]) { result, painting in
            result[painting.artist, default: 0] += 1
        }.map { ArtistItem(name: $0.key, count: $0.value) }
            .sorted { $0.name < $1.name }
    }

    init() {
        ImageStringCache.shared.clearCache()
        Task {
            await load()
        }
    }

    func load() async {
        do {
            paintings = try await PaintingsGeminiLoader.loadFromBundle()
        } catch {
            print("Failed to load paintingsGemini:", error)
        }
    }
    
    func filteredPaintings(selectedArtist: String) -> [PaintingGemini] {
        if selectedArtist.isEmpty {
            return paintings
        }
        return paintings.filter { $0.artist == selectedArtist }
    }

    func ensureValidSelection() {
        let currentArtists = artistItems
        let currentArtistNames = Set(currentArtists.map(\.name))

        if !currentArtists.isEmpty,
           !currentArtistNames.contains(selectedArtist),
           let first = currentArtists.first {
            selectedArtist = first.name
        }
    }
}
