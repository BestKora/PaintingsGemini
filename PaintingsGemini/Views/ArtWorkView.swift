//
//  ArtWorkView.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 25/01/2026.
//
import SwiftUI

struct ArtWorkView: View {
    let painting: Art //PaintingGemini
    @Environment(\.displayScale) private var displayScale
    @State private var reloadToken = UUID()
    
    var body: some View {
        VStack  (alignment: .leading){
                Text(painting.title)
                    .font(.headline)
            HStack  {
                Spacer()
                Text(painting.artist)
                    .foregroundStyle(.secondary)
            }
            
            Text("📍 \(painting.location)")
                .font(.subheadline)
           HStack {
                Spacer()
                Text(painting.style)
                    .foregroundStyle(.secondary)
            }
            let cacheKey = painting.title + painting.artist
            if let url = URL(string: painting.imageURL) {
                if let cached = ImageStringCache.shared.image(for: cacheKey) {
                    Text("--- Cached Image ---")
                    Image(uiImage: cached)
                        .resizable()
                        .scaledToFit()
                } else {
                    // Image from URL
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 80, height: 80)
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit() // scaledToFill()
                                .clipped()
                                .clipShape(.rect(cornerRadius: 8))
                                .onAppear {
                                    // Render SwiftUI Image to UIImage before caching
                                    let renderer = ImageRenderer(content: image)
                                    renderer.scale = displayScale
                                    if let uiImage = renderer.uiImage {
                                        ImageStringCache.shared.store(uiImage, for: cacheKey)
                                    }
                                }
                        case .failure:
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .frame(width: 80, height: 80)
                                    .foregroundStyle(.secondary)
                                Button("Retry") {
                                    reloadToken = UUID()
                                }
                                .buttonStyle(.bordered)
                            }
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .id(reloadToken)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = PaintingsGeminiViewModel()
    ArtWorkView( painting: PaintingGemini(
        title: "Carnation, Lily, Lily, Rose",
        artist: "John Singer Sargent",
        year: "1885–1886",
        style: "Impressionism",
        period: "Modern Era",
        location: "Tate Britain, London",
        estimateValue: "Priceless",
        imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/John_Singer_Sargent_-_Carnation%2C_Lily%2C_Lily%2C_Rose_-_Google_Art_Project.jpg/960px-John_Singer_Sargent_-_Carnation%2C_Lily%2C_Lily%2C_Rose_-_Google_Art_Project.jpg"))
    .padding()
}
