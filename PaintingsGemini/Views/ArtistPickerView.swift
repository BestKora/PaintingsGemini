//
//  ArtistPickerView.swift
//  ArtAdvisor
//
//  Created by Tatiana Kornilova on 22/01/2026.
//
import SwiftUI

struct ArtistPickerView: View {
    let filteredArtists: [ArtistItem]
    @Binding var selectedArtist: String

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            let artists = searchText.isEmpty
                ? filteredArtists
                : filteredArtists.filter { $0.name.localizedStandardContains(searchText) }

            List {
                Section("Created by") {
                    ForEach(artists, id: \.name) { artist in
                        Button {
                            selectedArtist = artist.name
                            dismiss()
                        } label: {
                            HStack {
                                Text(artist.name)
                                Spacer()
                                Text("\(artist.count)")
                                if artist.name == selectedArtist {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Artist")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("Search artist", text: $searchText)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .overlay {
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(.primary, lineWidth: 1)
                }
                .padding(.horizontal)
                .padding(.top)
                .background(.background)
            }
        }
    }
}
