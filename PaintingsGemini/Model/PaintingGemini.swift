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
    
  /*  var cost: Int {
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
    }*/
    
    var cost: Int {
        let normalized = estimateValue
            .replacing(",", with: "")
            .replacing("+", with: "")

        let moneyRegex = /(?:\$|[Uu][Ss][Dd]\s*)(\d+(?:\.\d+)?)\s*([Bb]illion|[Mm]illion|[Tt]housand)?/

        guard let match = normalized.firstMatch(of: moneyRegex),
              let amount = Double(match.output.1) else {
            return 0
        }

        let multiplier: Double
        switch (match.output.2.map { String($0).lowercased() } ?? "") {
        case "billion":
            multiplier = 1_000_000_000
        case "million":
            multiplier = 1_000_000
        case "thousand":
            multiplier = 1_000
        default:
            multiplier = 1
        }

        return Int((amount * multiplier).rounded())
    }
    
    var soldYear: Int? {
        let yearRegex = /\b(1[5-9]\d{2}|20\d{2})\b/
        guard let match = estimateValue.firstMatch(of: yearRegex) else { return nil }
        return Int(match.output.1)
    }
    
    var costString: String {
        let value = Double(cost)
        guard value > 0 else { return "Unknown" }

        let billion = 1_000_000_000.0
        let million = 1_000_000.0
        let thousand = 1_000.0

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        formatter.groupingSeparator = "," // for readability

        if value >= billion {
            let num = value / billion
            let text = formatter.string(from: NSNumber(value: num)) ?? "\(num)"
            return "$\(text) Billion"
        } else if value >= million {
            let num = value / million
            let text = formatter.string(from: NSNumber(value: num)) ?? "\(num)"
            return "$\(text) Million"
        } else if value >= thousand {
            let num = value / thousand
            let text = formatter.string(from: NSNumber(value: num)) ?? "\(num)"
            return "$\(text) Thousand"
        } else {
            // Plain dollars for smaller values
            let plain = NumberFormatter()
            plain.numberStyle = .currency
            plain.currencyCode = "USD"
            plain.maximumFractionDigits = 0
            return plain.string(from: NSNumber(value: value)) ?? "$\(Int(value))"
        }
    }
}
