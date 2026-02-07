//
//  MostPaintingsView.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 22/01/2026.
//

import SwiftUI

struct MostPaintingsView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case browse = "Browse"
        case mostExpensive = "Most Expensive"

        var id: String { rawValue }
    }

    @State private var mode: Mode = .browse

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Picker("View", selection: $mode) {
                    ForEach(Mode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                Group {
                    switch mode {
                    case .browse:
                        PaintingsGeminiView()
                    case .mostExpensive:
                        MostExpensivePaintingsView()
                    }
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
