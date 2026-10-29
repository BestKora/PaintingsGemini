//
//  PaintingsGeminiViewModel.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 27/12/2025.
//

import SwiftUI

nonisolated struct PaintingsGeminiLoader {

    @concurrent
    static func loadFromBundle() async throws -> [PaintingGemini] {
        guard let url = Bundle.main.url(
            forResource: "PaintingGemini",
            withExtension: "json"
        ) else {
            throw CocoaError(.fileNoSuchFile)
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(
            [PaintingGemini].self,
            from: data
        )
    }
}

@Observable @MainActor
final class PaintingsGeminiViewModel {
    var paintings: [PaintingGemini] = []
    var selectedArtist: String = ""
    
    private var hasLoadedPaintings = false
    
    var artists: [String] {
        Array(Set(paintings.map { $0.artist }))
    }
    
    var artistItems: [ArtistItem] {
        paintings.reduce(into: [:]) { result, painting in
            result[painting.artist, default: 0] += 1
        }.map { ArtistItem(name: $0.key, count: $0.value) }
            .sorted { $0.name < $1.name }
    }

    func load() async {
        do {
            paintings = try await PaintingsGeminiLoader.loadFromBundle()
            hasLoadedPaintings = true
        } catch {
            print("Failed to load paintingsGemini:", error)
        }
    }

    func loadIfNeeded() async {
        guard !hasLoadedPaintings else {
            return
        }
        await load()
        ImageStringCache.shared.clearCache()
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

