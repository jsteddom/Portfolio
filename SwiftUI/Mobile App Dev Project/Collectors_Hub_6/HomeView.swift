//
//  HomeView.swift
//  Collector's_Hub_5
//
//  Created by Jonathan Steddom on 11/29/24.
//

import SwiftUI
import SwiftData
import Foundation
import PhotosUI
import MapKit

struct HomeView: View {
    // Swift data variables
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var users: [userRecord]
    @ObservedObject var uModel = userModel()
    // Variable for selected user
    @State var selectedUser: String = ""
    // Toggle variable for AddView
    @State var toAddView = false
    // Toggle variable for map view
    @State var toMapView = false
    // Toggle variable for search view
    @State var toSearchView = false
    // Toggle Delete alert
    @State var toDeleteView = false
    @State var toDelete: String = ""
    // Alert for signout
    @State var toSignout: Bool = false
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 167/255, green: 169/255, blue: 172/255)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if let currentUser = users.first(where: { $0.name == selectedUser }) {
                        if currentUser.items.count == 0 {
                            VStack {
                                Text("You have no items yet.")
                                    .font(.custom("Verdana", size: 30))
                                    .bold()
                                HStack {
                                    Text("Press the ")
                                    Image(systemName: "plus.app")
                                        .foregroundColor(Color(red: 0/255, green: 80/255, blue: 136/255))
                                    Text(" to add an item.")
                                    
                                }
                            }
                        }
                        else {
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 8) {
                                    ForEach(currentUser.items) { item in
                                        NavigationLink(destination: ItemDetailView(item: item)) {
                                            // Link to item cell view
                                            ItemCell(item: item)
                                                .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        HStack {
                            Button(action: {
                                toSignout.toggle()
                            }, label: {
                                Image(systemName: "arrow.left.square.fill")
                            }
                            )}
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            // Add button
                            Button(action:
                                    {
                                toAddView.toggle()
                            },  label: {
                                Image(systemName:"plus.app")
                            }).sheet(isPresented: $toAddView) {
                                AddItemView(user: selectedUser)
                            }
                            Spacer()
                            // Delete button
                            Button(action: {
                                toDeleteView = true
                            }, label: {
                                Image(systemName: "trash")
                            }
                            )
                            Spacer()
                            // Search button
                            Button(action: {
                                toSearchView.toggle()
                            }, label: {
                                Image(systemName:"cabinet")
                            }).sheet(isPresented: $toSearchView){
                                searchView()
                            }
                            Spacer()
                            // Map button
                            Button(action: {
                                toMapView.toggle()
                            }, label: {
                                Image(systemName:"map")
                            }).sheet(isPresented: $toMapView){
                                // Default location is set to Tempe
                                findShopsTwo(location: "Tempe")
                            }
                        }
                    }
                }   // Alert for delete button
                .alert("Delete Item", isPresented: $toDeleteView, actions: {
                    TextField("Enter item name", text: $toDelete)
                    // Cancel button to exit view without deleting
                    Button("Cancel", role: .cancel, action: {
                        toDeleteView = false
                    })
                    // Call delete function and delete movie record based on movie name given
                    Button("Delete", action: {
                        if let currentUser = users.first(where: { $0.name == selectedUser }) {
                            if let index = currentUser.items.first(where: { $0.name == toDelete }) {
                                modelContext.delete(index)
                                toDelete = ""
                                // Try catch block to attempt to make save
                                do {
                                    try modelContext.save()
                                } catch {
                                    print("Error deleting entry: \(error)")
                                }
                            }
                        }
                    })
                }, message: {
                    Text("Enter name of item you would like to delete")
                })
                .alert("Sign out", isPresented: $toSignout, actions: {
                    Button("Cancel", role: .cancel, action: {
                        toSignout = false
                    })
                    Button("Sign out", action: {
                        dismiss()
                    })
                }, message: {
                    Text("Are you sure you want to sign out?")
                }
                )
            }
        }.navigationBarBackButtonHidden(true)
    }
}
// View for each item in list view
struct ItemCell: View {
    // Recieve item record from home view
    @State var item: itemRecord
    var body: some View {
        VStack {
            // Display item name and photo in list view
            if let photo = item.image,
            let uiImage = UIImage(data: item.image!) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    //.frame(maxWidth: 220, maxHeight: .infinity)
                    .frame(width: 220, height: 250)
                    .padding()
                    //.cornerRadius(20)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .clipped()
            }
        }
    }
}
// When user wants to add item, takes them to this view
struct AddItemView: View {
    // Swift data variables
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var users: [userRecord]
    // Get model variable
    @ObservedObject var uModel = userModel()
    // User entry variables for item
    @State var user = String()
    @State var options: [String] = ["Cards", "Figures", "Toy", "Comics", "Games", "Collectable"]
    @State var itemName: String = ""
    @State var itemInfo: String = ""
    @State var itemPrice: String = ""
    @State var date = Date()
    @State var location: String = ""
    @State var selectedType: String = ""
    // Photo selecting variables
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotoData: Data?
    @State var emptyData = Data()
    // Error message variable
    @State var error: String = ""
    var body: some View {
        Form {
            // Section for item information
            Section("Item Information") {
                TextField("Item Name", text: $itemName)
                TextField("Item Info", text: $itemInfo)
                TextField("Item Price", text: $itemPrice)
                Picker("Select type of collectable", selection: $selectedType){
                    ForEach(options, id: \.self){ option in
                        Text(option)
                    }
                }
            }
            // Section to select photo
            Section("Item photo") {
                if let selectedPhotoData,
                   let uiImage = UIImage(data: selectedPhotoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .cornerRadius(20)
                        .clipped()
                }
                // Picker to add photo from library
                PhotosPicker(selection: $selectedPhoto,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Label("Add Image", systemImage: "photo")
                }
                if selectedPhotoData != nil {
                    // Delete a photo button
                    Button(role: .destructive) {
                        withAnimation {
                            selectedPhoto = nil
                            selectedPhotoData = nil
                        }
                    } label: {
                        Label("Remove Image", systemImage: "xmark")
                            .foregroundStyle(.red)
                    }
                }
            }
            // Section to enter location and date purchased
            Section("Date and location item was purchased"){
                DatePicker("Enter date", selection: $date, displayedComponents: .date)
                TextField("City purchased", text: $location)
            }
            // Add button
            Button("Add item to collection", action: {
                if itemName.isEmpty || itemInfo.isEmpty || itemPrice.isEmpty || selectedType == "" || location.isEmpty {
                    error = "Please fill out all fields"
                }
                else {
                    error = ""
                    let newItem = uModel.addItem(name: itemName, itemInfo: itemInfo, price: itemPrice, date: date, image: selectedPhotoData ?? emptyData, location: location, type: selectedType)
                    for userC in users {
                        print("Currenet username in loop: \(userC.name)")
                        if userC.name == user {
                            print("User found: \(userC.name)")
                            // Apend item
                            userC.items.append(newItem)
                            // Try catch block to attempt to make save
                            do {
                                try modelContext.save()
                                print("Data item saved!")
                            } catch {
                                print("Error saving context: \(error)")
                            }
                        }
                    }
                    dismiss()
                }
            })
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                selectedPhotoData = data
            }
        }
        Text(error)
            .foregroundColor(.red)
    }
}
struct ItemDetailView: View {
    // Swift data variables
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @Query private var users: [userRecord]
    // Model variable
    @ObservedObject var uModel = userModel()
    // Item record
    @State var item: itemRecord
    // Get map model
    @StateObject var map = mapModel()
    // Boolean to execute search when button pressed
    @State var searchPresented: Bool = false
    var body: some View {
        ZStack {
            Color(red: 167/255, green: 169/255, blue: 172/255)
                .edgesIgnoringSafeArea(.all)
                VStack {
                    if let photo = item.image,
                    let uiImage = UIImage(data: item.image!) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 350, maxHeight: .infinity)
                            .cornerRadius(20)
                            .clipped()
                    }
                    List {
                        Text("Item: ")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                        Text(item.name)
                            .font(.custom("Verdana", size: 14))
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                        Text("Item type: ")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                        Text(item.type)
                            .font(.custom("Verdana", size: 14))
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                        Text("Price: ")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                        Text(item.price)
                            .font(.custom("Verdana", size: 14))
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                        Text("Description: ")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                        Text(item.itemInfo)
                            .font(.custom("Verdana", size: 14))
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                        Text("Location Purchased: ")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                            .listRowBackground(Color(red: 167/255, green: 169/255, blue: 172/255))
                    }
                    .background(Color(red: 167/255, green: 169/255, blue: 172/255))
                    .scrollContentBackground(.hidden)
            }
            
        }
    }
}
// View for finding shops
struct findShopsTwo: View {
    // User input variables
    @State var location: String
    @State var searchText: String = ""
    // Get map model
    @StateObject var map = mapModel()
    var body: some View {
        VStack {
            // Line for location change
            HStack {
                TextField("Change location", text: $location)
                    .font(.custom("Verdana", size: 24))
                Button(action: {
                    map.forwardGeocoding(cityName: location)
                }, label: {
                    Image(systemName: "magnifyingglass")
                }
            )}
            // Line for search entry
            HStack {
                TextField("Search", text: $searchText)
                    .font(.custom("Verdana", size: 24))
                Button(action: {
                    map.searchLocation(searchText: searchText)
                }, label: {
                    Image(systemName: "magnifyingglass")
                }
            )}
            .padding(.bottom, 10)
            // Display map
            Map(coordinateRegion: $map.region, annotationItems: map.markers) { location in
                // Create a map annotation. Will display city name and a map marker (pin)
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        // Display city name
                        Text(location.name)
                            .font(.caption)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                        // Display pin image
                        Image(systemName: "mappin.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                map.searchLocation(searchText: searchText)
            }
        }
        .background(Color(red: 167/255, green: 169/255, blue: 172/255))
    }
}

#Preview {
    HomeView()
}
