//
//  PaintingsGeminiApp.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 27/12/2025.
//

import SwiftUI

@main
struct PaintingsGeminiApp: App {
    @State private var viewModel: PaintingsGeminiViewModel

    init() {
        let viewModel = PaintingsGeminiViewModel()
        viewModel.load()
        _viewModel = State(initialValue: viewModel)
    }

    var body: some Scene {
        WindowGroup {
            MostPaintingsView(viewModel: viewModel)
        }
    }
}
