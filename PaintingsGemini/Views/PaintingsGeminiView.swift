//
//  PaintingsGrokManager.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 27/12/2025.
//

import SwiftUI

struct PaintingsGeminiView: View {
    @Bindable var viewModel: PaintingsGeminiViewModel
  //  @Environment(\.viewModel) private var viewModel
    @State private var isArtistSheetPresented = false

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        VStack {
            let paintings = viewModel.filteredPaintings(selectedArtist: viewModel.selectedArtist)

            Text("Choose the artist to fetch paintings from local DB.")

            Button {
                isArtistSheetPresented = true
            } label: {
                HStack {
                    Text(viewModel.selectedArtist.isEmpty ? "Search artist" : viewModel.selectedArtist)
                        .foregroundStyle(viewModel.selectedArtist.isEmpty ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.quaternary, lineWidth: 1)
                }
            }
            .buttonStyle(.plain)

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
        .onChange(of: viewModel.artistItems) { _, _ in
            viewModel.ensureValidSelection()
        }
        .sheet(isPresented: $isArtistSheetPresented) {
            ArtistPickerView(filteredArtists: viewModel.artistItems, selectedArtist: $viewModel.selectedArtist)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    PaintingsGeminiView(viewModel: PaintingsGeminiViewModel())
}
