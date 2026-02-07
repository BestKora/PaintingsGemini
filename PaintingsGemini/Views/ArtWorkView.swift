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
            if let url = URL (string: painting.imageURL)/*painting.URLImage*/ {
                if let cached = ImageStringCache.shared.image (for: painting.title + painting.artist) {
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
                                .scaledToFill()
                                .clipped()
                                .cornerRadius(8)
                                .onAppear {
                                    // Render SwiftUI Image to UIImage before caching
                                    let renderer = ImageRenderer(content: image)
                                    renderer.scale = displayScale
                                    if let uiImage = renderer.uiImage {
                                        ImageStringCache.shared.store(uiImage, for: painting.title + painting.artist)
                                    }
                                }
                        case .failure:
                            Image(systemName: "photo")
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.secondary)
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
}
