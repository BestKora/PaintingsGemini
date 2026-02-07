//
//  PaintingsGrokManager.swift
//  ArtAdvisor
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
   var artists: [String] {
        Array(Set(paintings.map {$0.artist}))
    }
    var artistItems: [ArtistItem] {
        paintings.reduce(into: [:]) { result, painting in
            result[painting.artist, default: 0] += 1
        }.map { ArtistItem(name: $0.key, count: $0.value) }
            .sorted { $0.name < $1.name}
    }

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
}

struct PaintingsGeminiView: View {
    @Bindable var viewModel: PaintingsGeminiViewModel
    @State private var searchText = ""
    @State var selectedArtist = "Claude Monet"

    var body: some View {
        VStack {
            Text("Choose the artist to fetch paintings from local DB.")
            TextField("Search artist", text: $searchText, axis: .vertical)
                .font(.headline)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.send)
            ArtistPickerView(filteredArtists: filteredArtists, selectedArtist: $selectedArtist)
        /*    List (filteredPaintings /*vm.paintings*/) { painting in
                ArtWorkView(painting: painting)*/
            ScrollView {
                         LazyVStack(alignment: .leading, spacing: 16) {
                             ForEach(filteredPaintings) { painting in
                                 ArtWorkView(painting: painting)
                             }
                         }
                         .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal)
        .navigationTitle("Paintings Gemini")
        .onChange(of: filteredArtists) {
            if  !filteredArtists.isEmpty && !filteredArtists.map({$0.name}).contains(selectedArtist) {
                selectedArtist = filteredArtists.first!.name
            }
        }
    }
    var filteredArtists: [ArtistItem]  {
        if searchText.isEmpty {
            return viewModel.artistItems
        } else {
            return viewModel.artistItems.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filteredPaintings: [PaintingGemini]  {
        if selectedArtist.isEmpty {
            return viewModel.paintings
        } else {
            return viewModel.paintings.filter {
                $0.artist.localizedCaseInsensitiveContains(selectedArtist)
            }
        }
    }
}

#Preview {
    PaintingsGeminiView(viewModel: PaintingsGeminiViewModel())
}
