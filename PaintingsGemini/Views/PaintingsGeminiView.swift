//
//  PaintingsGrokManager.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 27/12/2025.
//

import SwiftUI

struct PaintingsGeminiView: View {
   var isSelected : Bool
    
    @Bindable var viewModel: PaintingsGeminiViewModel
    @State private var searchText = ""
    @State var selectedArtist = "Claude Monet"
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
                .submitLabel(.send)
            ArtistPickerView(filteredArtists: filteredArtists, selectedArtist: $selectedArtist)
            List (filteredPaintings ) { painting in
                ArtWorkView(painting: painting)
        /*    ScrollView {
                         LazyVStack(alignment: .leading, spacing: 16) {
                             ForEach(filteredPaintings) { painting in
                                 ArtWorkView(painting: painting)
                             }
                         }
                         .frame(maxWidth: .infinity, alignment: .leading)*/
            }
        }
        .padding(.horizontal)
        .navigationTitle("Paintings Gemini")
        .onChange(of: filteredArtists) {
            if  !filteredArtists.isEmpty && !filteredArtists.map({$0.name}).contains(selectedArtist) {
                selectedArtist = filteredArtists.first!.name
            }
        }
        .onChange(of: isSelected) { _, newValue in
                    if newValue {
                        // Tab was selected
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isArtistFieldFocused = true
                        }
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
    PaintingsGeminiView(isSelected: true, viewModel: PaintingsGeminiViewModel())
}
