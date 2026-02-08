//
//  TitlePaintingsView.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 22/01/2026.
//

import SwiftUI

struct TitlePaintingsView: View {
    @Bindable var viewModel: PaintingsGeminiViewModel
    @State private var titleQuery = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filter paintings by title.")
                .font(.headline)

            TextField("Search title", text: $titleQuery, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)

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
        .navigationTitle("Titles")
    }

    private var filteredPaintings: [PaintingGemini] {
        if titleQuery.isEmpty {
            return viewModel.paintings
        }
        return viewModel.paintings.filter {
            $0.title.localizedCaseInsensitiveContains(titleQuery)
        }
    }
}

#Preview {
    TitlePaintingsView(viewModel: PaintingsGeminiViewModel())
}
