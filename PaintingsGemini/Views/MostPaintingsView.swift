//
//  MostPaintingsView.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 22/01/2026.
//

import SwiftUI

struct MostPaintingsView: View {
    @Bindable var viewModel: PaintingsGeminiViewModel
    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                Tab("Artists", systemImage: "person.3.fill", value: 0) {
                    PaintingsGeminiView(isSelected: selectedTab == 0, viewModel: viewModel)
                }

                Tab("Expensive Paintings", systemImage: "dollarsign.circle", value: 1) {
                    MostExpensivePaintingsView(viewModel: viewModel)
                }

                Tab("Titles", systemImage: "text.magnifyingglass", value: 2) {
                    TitlePaintingsView(isSelected: selectedTab == 2, viewModel: viewModel)
                }
            }
        }
    }
}

struct MostExpensivePaintingsView: View {
    @Bindable var viewModel: PaintingsGeminiViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Most expensive paintings from the local collection.")
                .font(.headline)
                .padding(.horizontal)
            List (topPaintings) { painting in
                VStack {
                    ArtWorkView(painting: painting)
                    Text("Estimated value: \(painting.estimateValue)")
                        .font(.headline)
                        .foregroundStyle(.blue)
                }
           /* ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(topPaintings) { painting in
                        VStack(alignment: .leading, spacing: 6) {
                            ArtWorkView(painting: painting)
                            Text("Estimated value: \(painting.estimateValue)")
                                .font(.headline)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)*/
            }
        }
        .padding(.horizontal)
        .navigationTitle("Most Expensive")
    }

    private var topPaintings: [PaintingGemini] {
        let sorted = viewModel.paintings.sorted { $0.cost > $1.cost }
        return Array(sorted.prefix(50))
    }
}

#Preview {
    MostPaintingsView(viewModel: PaintingsGeminiViewModel())
}
