//
//  PaintingsGrokManager.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 27/12/2025.
//

import SwiftUI

struct PaintingsGeminiView: View {
    var isSelected: Bool
    
    @Bindable var viewModel: PaintingsGeminiViewModel
    @State private var searchText = ""
    @State private var selectedArtist = "Claude Monet"
    @FocusState private var isArtistFieldFocused: Bool

    var body: some View {
        VStack {
            Text("Choose the artist to fetch paintings from local DB.")
            TextField("Search artist", text: $searchText, axis: .vertical)
                .font(.headline)
                .textFieldStyle(.roundedBorder)
                .focused($isArtistFieldFocused)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit {
                    if let first = filteredArtists.first {
                        selectedArtist = first.name
                    }
                }
            
            if filteredArtists.map({$0.name}).contains(selectedArtist) {
                ArtistPickerView(filteredArtists: filteredArtists, selectedArtist: $selectedArtist)
            }
            if filteredPaintings.isEmpty {
                ContentUnavailableView("No paintings", systemImage: "photo.on.rectangle.angled", description: Text("Try another artist or clear search"))
            } else {
                List(filteredPaintings) { painting in
                    ArtWorkView(painting: painting)
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle("Paintings by Artist")
        .onChange(of: filteredArtists) {
            if !filteredArtists.isEmpty,
               !filteredArtists.map(\.name).contains(selectedArtist),
               let firstArtist = filteredArtists.first {
                selectedArtist = firstArtist.name
            }
        }
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(100))
                    isArtistFieldFocused = true
                }
            }
        }
    }

    var filteredArtists: [ArtistItem] {
        if searchText.isEmpty {
            return viewModel.artistItems
        }

        return viewModel.artistItems.filter {
            $0.name.localizedStandardContains(searchText)
        }
    }

    var filteredPaintings: [PaintingGemini] {
        if selectedArtist.isEmpty {
            return viewModel.paintings
        }

        return viewModel.paintings.filter {
            $0.artist.localizedStandardContains(selectedArtist)
        }
    }
}

#Preview {
    PaintingsGeminiView(isSelected: true, viewModel: PaintingsGeminiViewModel())
}
