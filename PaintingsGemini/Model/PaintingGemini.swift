//
//  PaintingGemini.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 22/01/2026.
//
import Foundation
import FoundationModels

@Generable
struct PaintingGemini: Decodable, Identifiable, Equatable , Art {
    
  let title: String
  let artist: String
  let year: String
  let style: String
  let period: String
  let location: String
  let estimateValue: String
  let imageURL: String
    
  var id:String {title + artist}
    
    // Исключаем id из декодирования
    private enum CodingKeys: String, CodingKey {
        case title
        case artist
        case year
        case style
        case period
        case location
        case estimateValue = "estimated_value"
        case imageURL = "image_url"
    }
       
    var description : String {
        "\(title) by \(artist) from \(year) location \(location)"
    }
    var URLImage : URL? {
     URL(string: imageURL)
    }
    var cost: Int {
        let formatter = NumberFormatter()
        let usLocale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.locale = usLocale
     
        if let range = estimateValue.range(of: "Million") {
            let beforeMillion = estimateValue[..<range.lowerBound].trimmingCharacters(in: .whitespaces)
            let usCurrency = formatter.number(from: beforeMillion) ?? 0.0
            return Int(truncating: usCurrency)
        }
       return 0
    }
}
