//
//  mapModel.swift
//  Collector's_Hub_5
//
//  Created by Jonathan Steddom on 11/29/24.
//
import Foundation
import SwiftUI
import MapKit

// Struct for find shops view
struct LocationTwo: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

// Map model
class mapModel: ObservableObject {
    var coordinate: CLLocationCoordinate2D?
    // Default coordinates
    @State static var defaultLocation = CLLocationCoordinate2D(
        latitude: 33.4255,
        longitude: -111.9400
    )
    // Region variable. Set with default coordinates
    @Published var region = MKCoordinateRegion(
        center: defaultLocation,
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    // Markers dictionary, default to tempe location
    @Published var markers = [
        LocationTwo(name: "Tempe", coordinate: defaultLocation)
    ]
    // Function to get location of city name
    func forwardGeocoding(cityName: String)
    {
        // Geocoder object
        _ = CLGeocoder();
        // variable for city name
        let cityString = cityName
        CLGeocoder().geocodeAddressString(cityString, completionHandler:
                                            {(placemarks, error) in
            
            if error != nil {
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                let placemark = placemarks![0]
                let location = placemark.location
                let coords = location!.coordinate
                print(coords.latitude)
                print(coords.longitude)
                // Ajust variables to set location to city location
                DispatchQueue.main.async
                    {
                        self.region.center = coords
                        self.markers[0].name = placemark.locality!
                        self.markers[0].coordinate = coords
                    }
            }
        })
    }
    // Search function
    func searchLocation(searchText: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        searchRequest.region = region
        // Local search
        MKLocalSearch(request: searchRequest).start {response, error in
            guard let response = response else {
                print("Error")
                return
            }
            // Debugging: Print the number of results returned
            print("Number of map items: \(response.mapItems.count)")
            // Limit the results to the first 10
            let limitedMapItems = Array(response.mapItems.prefix(10))
            
            DispatchQueue.main.async {
                self.region = response.boundingRegion
                self.markers = limitedMapItems.map { item in
                // Location name and coordinate assignment for places
                LocationTwo(
                    name: item.name ?? "Unknown",
                    coordinate: item.placemark.coordinate
                )}
            }
        }
    }
}
