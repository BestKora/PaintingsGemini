//
//  MostPaintingsView.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 22/01/2026.
//

import SwiftUI

struct MostPaintingsView: View {
    @State private var viewModel = PaintingsGeminiViewModel()

    var body: some View {
        NavigationStack {
            TabView {
                PaintingsGeminiView(viewModel: viewModel)
                    .tabItem {
                        Label("Artists", systemImage: "person.3.fill")
                    }

                MostExpensivePaintingsView()
                    .tabItem {
                        Label("Expensive Paintings", systemImage: "dollarsign.circle")
                    }
            }
        }
    }
}

struct MostExpensivePaintingsView: View {
    @State var vm = PaintingsGeminiViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Most expensive paintings from the local collection.")
                .font(.headline)
                .padding(.horizontal)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(topPaintings) { painting in
                        ArtWorkView(painting: painting)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
        }
        .onAppear {
            vm.load()
            ImageStringCache.shared.clearCache()
        }
        .navigationTitle("Most Expensive")
    }

    private var topPaintings: [PaintingGemini] {
        let sorted = vm.paintings.sorted { $0.cost > $1.cost }
        return Array(sorted.prefix(10))
    }
}

#Preview {
    MostPaintingsView()
}
