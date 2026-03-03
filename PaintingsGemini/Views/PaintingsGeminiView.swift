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
    @FocusState private var isArtistFieldFocused: Bool

    var body: some View {
        VStack {
            let artists = viewModel.filteredArtists(searchText: viewModel.debouncedSearchText)
            let paintings = viewModel.filteredPaintings(selectedArtist: viewModel.selectedArtist)
            let artistNames = Set(artists.map(\.name))

            Text("Choose the artist to fetch paintings from local DB.")
            TextField("Search artist", text: $viewModel.searchText, axis: .vertical)
                .font(.headline)
                .textFieldStyle(.roundedBorder)
                .focused($isArtistFieldFocused)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit {
                    if let first = artists.first {
                        viewModel.selectedArtist = first.name
                    }
                }
            
          //  if artists.map({ $0.name }).contains(viewModel.selectedArtist) {
            if artistNames.contains(viewModel.selectedArtist) {
                ArtistPickerView(filteredArtists: artists, selectedArtist: $viewModel.selectedArtist)
            } else {
                Text(viewModel.selectedArtist)
            }
            if paintings.isEmpty {
                ContentUnavailableView("No paintings", systemImage: "photo.on.rectangle.angled", description: Text("Try another artist or clear search"))
            } else {
                List(paintings) { painting in
                    ArtWorkView(painting: painting)
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle("Paintings by Artist")
        .onAppear {
            if viewModel.selectedArtist.isEmpty, let first = viewModel.artistItems.first?.name {
                viewModel.selectedArtist = first
            }
        }
        .onChange(of: viewModel.debouncedSearchText) { _, _ in
            viewModel.ensureValidSelection()
        }
        .onChange(of: viewModel.artistItems) { _, _ in
            viewModel.ensureValidSelection()
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
}

#Preview {
    PaintingsGeminiView(isSelected: true, viewModel: PaintingsGeminiViewModel())
}
