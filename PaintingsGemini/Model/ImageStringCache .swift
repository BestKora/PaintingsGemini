//
//  ImageStringCache .swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 22/01/2026.
//
import Foundation
import UIKit

// Singleton memory cache with String
class ImageStringCache {
    static let shared = ImageStringCache()
    let cache = NSCache<NSString, UIImage>()
    
    func image(for title: String) -> UIImage? {
        cache.object(forKey: title  as NSString)
    }
    
    func store(_ image: UIImage, for title: String) {
        cache.setObject(image, forKey: title as NSString)
    }
    
    // MARK: - Clear the entire cache
     func clearCache() {
            cache.removeAllObjects()
            print("Image cache cleared – all images removed from memory")
        }
        
        // Optional: Clear only one specific image
    func removeImage(for title: String) {
            cache.removeObject(forKey: title as NSString)
    }
}
