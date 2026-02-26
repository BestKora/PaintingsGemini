//
//  MostExpensivePaintingsView.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 26/02/2026.
//
import SwiftUI

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
            }
        }
        .padding(.horizontal)
        .navigationTitle("Most Expensive")
    }

    private var topPaintings: [PaintingGemini] {
        viewModel.paintings.filter {$0.cost > 0}.sorted { $0.cost > $1.cost }
       
    }
}

#Preview {
    MostExpensivePaintingsView (viewModel: PaintingsGeminiViewModel())
}
