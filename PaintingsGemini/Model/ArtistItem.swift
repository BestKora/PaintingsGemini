//
//  ArtistItem.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 22/01/2026.
//
import Foundation

struct ArtistItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let count: Int 
}
