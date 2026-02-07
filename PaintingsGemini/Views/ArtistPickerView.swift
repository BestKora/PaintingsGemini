//
//  ArtistPickerView.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 22/01/2026.
//
import SwiftUI

struct ArtistPickerView: View {
    let filteredArtists: [ArtistItem]
    @Binding  var selectedArtist: String

    var body: some View {
        VStack {
            Picker("Artist", selection: $selectedArtist) {
                ForEach(filteredArtists, id: \.name) { artist in
                    Text("\(artist.name) (\(artist.count))")
                        .tag(artist.name)
                }
            }
        }
        .navigationTitle("Artist")
    }
}
