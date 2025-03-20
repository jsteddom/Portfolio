//
//  GoogleSearchAPI.swift
//  Collector's_Hub_5
//
//  Created by Jonathan Steddom on 11/29/24.
//

import SwiftUI
import Foundation
import UIKit

// Model for API call
class apiCall: ObservableObject {
    // Variable for google reponse
    @Published var searchResults: [GoogleSearchResponse.Item] = []
    func searchGoogleImages(query: String) {
        // API keys for Google search
        let apiKey = "AIzaSyBFlx4VHQ4ToSPmPSi6TsaSyBRdS5duO2Y"
        let cx = "64a1276680aa042c4"
        // URL for custom search
        let urlString = "https://www.googleapis.com/customsearch/v1"
        
        guard var urlComponents = URLComponents(string: urlString) else { return }
        // Modified query to find purchasing related searches
        let modifiedQuery = query + "Display"
        // Query items for search
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "cx", value: cx),
            URLQueryItem(name: "searchType", value: "image"),
            URLQueryItem(name: "q", value: modifiedQuery),
            URLQueryItem(name: "num", value: "10")
        ]
        
        guard let url = urlComponents.url else { return }
        
        // Create URL session
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Error handling
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                // Decode JSON response
                var decodedResponse = try JSONDecoder().decode(GoogleSearchResponse.self, from: data)
                // Get first item in the response
                if var item = decodedResponse.items.first {
                    let title = item.title
                    let imageURL = item.image.thumbnailLink
                    let itemURL = item.link
                    // Print for debugging
                    print("Title: \(title)")
                    print("Image URL: \(imageURL)")
                    print("Webpage URL: \(itemURL)")
                    // Updated the array with search restuls
                    DispatchQueue.main.async {
                        self.searchResults = decodedResponse.items
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
}
