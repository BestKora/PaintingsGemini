//
//  PaintingsGrokManager.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 27/12/2025.
//

import SwiftUI

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
