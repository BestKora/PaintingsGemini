//
//  TitlePaintingsView.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 22/01/2026.
//

import SwiftUI

struct TitlePaintingsView: View {
    var isSelected : Bool
    
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
                .onSubmit {
                   isTitleFieldFocused = false
                }

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
        .onChange(of: isSelected) { _, newValue in
                    if newValue {
                        // Tab was selected
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
            $0.title.localizedCaseInsensitiveContains(titleQuery)
        }
    }
}

#Preview {
    TitlePaintingsView(isSelected: true, viewModel: PaintingsGeminiViewModel())
}
