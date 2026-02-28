//
//  TitlePaintingsView.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 22/01/2026.
//

import SwiftUI

struct TitlePaintingsView: View {
    var isSelected: Bool
    
    @Bindable var viewModel: PaintingsGeminiViewModel
    @State private var titleQuery = ""
    @FocusState private var isTitleFieldFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Filter paintings by title.")
                .font(.headline)

            TextField("Search title", text: $titleQuery, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isTitleFieldFocused)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.search)
            List(filteredPaintings) { painting in
                ArtWorkView(painting: painting)
            }
        }
        .padding(.horizontal)
        .navigationTitle("Titles")
        .onChange(of: isSelected) { _, newValue in
                    if newValue {
                        // Tab was selected
                        Task { @MainActor in
                            try? await Task.sleep(for: .milliseconds(100))
                            isTitleFieldFocused = true
                        }
                    }
        }
    }

    private var filteredPaintings: [PaintingGemini] {
        if titleQuery.isEmpty {
            return viewModel.paintings
        }
        return viewModel.paintings.filter {
            $0.title.localizedStandardContains(titleQuery)
        }
    }
}

#Preview {
    TitlePaintingsView(isSelected: true, viewModel: PaintingsGeminiViewModel())
}
