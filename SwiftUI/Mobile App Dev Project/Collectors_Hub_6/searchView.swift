//
//  searchView.swift
//  Collector's_Hub_5
//
//  Created by Jonathan Steddom on 11/29/24.
//

import SwiftUI
import Foundation
import UIKit

// This is where users will search for other items and be returned images
struct searchView: View {
    // Search variables
    @State private var searchText = ""
    @State private var isSearch = false
    // Get search model
    @ObservedObject var searchModel = apiCall()
    var body: some View {
        VStack {
            Text("Find display ideas!")
                .font(.custom("Verdana", size: 24))
            HStack {
                TextField("Enter a collectable type to find ideas!", text: $searchText)
                    .font(.custom("Verdana", size: 18))
                Button(action: {
                    // Execute Search
                    searchModel.searchGoogleImages(query: searchText)
                }, label: {
                    Image(systemName: "magnifyingglass")
                })
            }
            Section {
                // Iterate through response
                List(searchModel.searchResults) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                            .font(.headline)
                        AsyncImage(url: URL(string: item.image.thumbnailLink)) { phase in
                            switch phase {
                            // If image is recieved, display it
                            case .success(let image):
                                image.resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            // If image cannot be displayed, display default
                            case .failure(_):
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            // Default case
                            default:
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 100, height: 100)
                            }
                        }
                        // Link to view image
                        Link("View Image", destination: URL(string: item.link)!)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top, 2)
                    }
                }
            }
        }
    }
}
