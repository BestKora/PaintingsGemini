//
//  ArtWorkViewService.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 19/10/2026.
//



import SwiftUI

struct ArtWorkViewService: View {
    let painting: Art    
    var cache: ImageCache

    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var reloadToken = UUID()

    var body: some View {
        VStack(alignment: .leading) {
            Text(painting.title)
                .font(.headline)

            HStack {
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

            imageContent
        }
        .task(id: reloadToken) {
            await loadImage(cache: cache)
        }
    }

    @ViewBuilder
    private var imageContent: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 8))

        } else if isLoading {
            ProgressView("Loading painting…")
                .frame(maxWidth: .infinity, minHeight: 100)

        } else {
            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)

                Text("Unable to load image")

                Button("Retry") {
                    reloadToken = UUID()
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity, minHeight: 100)
        }
    }

    @MainActor
    private func loadImage(cache: ImageCache) async {
        guard let url = URL(string: painting.imageURL) else {
            image = nil
            isLoading = false
            return
        }

        isLoading = true
        image = nil

        defer {
            isLoading = false
        }

        let downloadedImage = await ServiceImage.getImage(url, cache: cache)
       // guard !Task.isCancelled else { return }

                if let downloadedImage {
                    image = downloadedImage
                } else {
                    isLoading = false
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
