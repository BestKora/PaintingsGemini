//
//  ServiceImage.swift
//  PaintingsGemini
//
//  Created by Tatiana Kornilova on 19/10/2026.
//

import SwiftUI
/*
nonisolated struct ServiceImage {
    
    @concurrent private static func download(_ url: URL) async -> (URL, UIImage)? {
        do {
            let (data, response)  = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let image = UIImage(data: data) else { return nil }
            return (url, image)
        } catch {
            return nil   // log or surface the error as needed
        }
    }
    
    @concurrent static func getImage (_ url: URL, cache: ImageCache) async -> UIImage? {
        if let image  = await cache.image(for: url) {
            return image
        } else {
            if let (urlN,image) = await download(url) {
                await cache.store(image, for: urlN)
                return image
            } else {
                return nil
            }
        }
    }
}

actor ImageCache {
    private var images: [URL: UIImage] = [:]

    func image(for url: URL) -> UIImage? { images[url] }
    func contains(_ url: URL) -> Bool { images[url] != nil }
    func store(_ image: UIImage, for url: URL) { images[url] = image }
}
*/
nonisolated struct ServiceImage {

    @concurrent
    static func getImage(
        _ url: URL,
        cache: ImageCache
    ) async -> UIImage? {
        guard let data = await cache.data(for: url) else {
            return nil
        }

        return UIImage(data: data)
    }
}

actor ImageCache {
    private var images: [URL: Data] = [:]

    private struct InFlight {
        let id: UUID
        let task: Task<Data?, Never>
    }

    private var inFlight: [URL: InFlight] = [:]

    func data(for url: URL) async -> Data? {
        // 1. Return a completed download.
        if let cachedData = images[url] {
            return cachedData
        }

        // 2. Join a download already in progress.
        if let pending = inFlight[url] {
            return await pending.task.value
        }

        // 3. Start one download for this URL.
        let requestID = UUID()

        let task = Task<Data?, Never> {
            await Self.downloadData(for: url)
        }

        inFlight[url] = InFlight(
            id: requestID,
            task: task
        )

        let downloadedData = await task.value

        // 4. Only the matching request can update the cache.
        if inFlight[url]?.id == requestID {
            inFlight[url] = nil

            if let downloadedData {
                images[url] = downloadedData
            }
        }

        return downloadedData
    }

    @concurrent
    private static func downloadData(
        for url: URL
    ) async -> Data? {
        do {
            let (data, response) =
                try await URLSession.shared.data(from: url)

            guard let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  UIImage(data: data) != nil
            else {
                return nil
            }

            return data
        } catch {
            return nil
        }
    }

    func removeAll() {
        images.removeAll()

        for pending in inFlight.values {
            pending.task.cancel()
        }

        inFlight.removeAll()
    }

    var count: Int {
        images.count
    }
}
