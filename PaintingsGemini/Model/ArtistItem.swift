//
//  ArtistItem.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 22/01/2026.
//
import Foundation

struct ArtistItem: Identifiable, Hashable {
    let name: String
    let count: Int
    
    var id:String {name}
}
