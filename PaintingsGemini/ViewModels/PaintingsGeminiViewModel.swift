//
//  PaintingsGeminiViewModel.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 27/12/2025.
//

import SwiftUI

enum PaintingsGeminiLoader {
    static func loadFromBundle() throws -> [PaintingGemini] {
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
    }
}

@Observable @MainActor
final class PaintingsGeminiViewModel {
    var paintings: [PaintingGemini] = []
    var searchText: String = "" {
        didSet {
            // debounce 300ms
            searchDebounceTask?.cancel()
            searchDebounceTask = Task { [searchText] in
                try? await Task.sleep(for: .milliseconds(300))
                await MainActor.run {
                    self.debouncedSearchText = searchText
                }
            }
        }
    }
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

    // Debounced search support
    var debouncedSearchText: String = ""
    private var searchDebounceTask: Task<Void, Never>? = nil

    init() {
        ImageStringCache.shared.clearCache()
        load()
    }

    func load() {
        do {
            paintings = try PaintingsGeminiLoader.loadFromBundle()
        } catch {
            print("Failed to load paintingsGemini:", error)
        }
    }
    
    func filteredArtists(searchText: String) -> [ArtistItem] {
        if searchText.isEmpty {
            return artistItems
        }
        return artistItems.filter { $0.name.localizedStandardContains(searchText) }
    }

    func filteredPaintings(selectedArtist: String) -> [PaintingGemini] {
        if selectedArtist.isEmpty {
            return paintings
        }
        return paintings.filter { $0.artist == selectedArtist }
    }
    
    // In PaintingsGeminiViewModel
    func ensureValidSelection() {
        let currentArtists = filteredArtists(searchText: debouncedSearchText)
        if !currentArtists.isEmpty,
           !currentArtists.map(\.name).contains(selectedArtist),
           let first = currentArtists.first {
            selectedArtist = first.name
        }
    }
}

