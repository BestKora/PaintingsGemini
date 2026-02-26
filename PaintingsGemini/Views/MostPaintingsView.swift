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


#Preview {
    MostPaintingsView(viewModel: PaintingsGeminiViewModel())
}
