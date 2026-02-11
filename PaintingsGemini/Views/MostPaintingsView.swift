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
            TabView (selection: $selectedTab) {
                PaintingsGeminiView(isSelected: selectedTab == 0, viewModel: viewModel)
                    .tabItem {
                        Label("Artists", systemImage: "person.3.fill")
                    }
                    .tag(0)

                MostExpensivePaintingsView(viewModel: viewModel)
                    .tabItem {
                        Label("Expensive Paintings", systemImage: "dollarsign.circle")
                    }
                    .tag(1)

                TitlePaintingsView(isSelected: selectedTab == 2,viewModel: viewModel)
                    .tabItem {
                        Label("Titles", systemImage: "text.magnifyingglass")
                    }
                    .tag(2)
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

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(topPaintings) { painting in
                        VStack(alignment: .leading, spacing: 6) {
                            ArtWorkView(painting: painting)
                            Text("Estimated value: \(painting.estimateValue)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
        }
        .navigationTitle("Most Expensive")
    }

    private var topPaintings: [PaintingGemini] {
        let sorted = viewModel.paintings.sorted { $0.cost > $1.cost }
        return Array(sorted.prefix(10))
    }
}

#Preview {
    MostPaintingsView(viewModel: PaintingsGeminiViewModel())
}
