//
//  ContentView.swift
//  Collectors_Hub_6
//
//  Created by Mitchie Steddom on 11/30/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [userRecord]
    var backgroundC = Color(red: 167/255, green: 169/255, blue: 172/255)
    // .background(Color(red: 167/255, green: 169/255, blue: 172/255))
    var body: some View {
            NavigationView {
                ZStack {
                    Color(red: 167/255, green: 169/255, blue: 172/255)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer().frame(height: 100)
                        Text("Welcome!")
                            .font(.custom("Verdana", size: 50))
                            .bold()
                        Text("Please sign in!")
                            .padding(.bottom, 100)
                            .font(.custom("Verdana", size: 30))
                        // Stack for log in view and sign up options
                        HStack(spacing: 100) {
                            NavigationLink(destination: logInView()) {
                                Text("Log In")
                                    .font(.custom("Verdana", size: 24))
                                    .foregroundColor(Color(red: 0/255, green: 80/255, blue: 136/255))
                            }
                            NavigationLink(destination: signUpView()){
                                Text("Sign Up")
                                    .font(.custom("Verdana", size: 24))
                                    .foregroundColor(Color(red: 0/255, green: 80/255, blue: 136/255))
                            }
                        }
                        .padding()
                    }
                }
            .navigationBarBackButtonHidden(true)
        }
    }
    
}
// View if user is selects login
struct logInView: View {
    // Swift data variables
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [userRecord]
    // View model object
    @ObservedObject var uModel = userModel()
    // Text field variables
    @State var username: String = ""
    @State var password: String = ""
    // Boolean for verifying login credentials
    @State var homeView: Bool = false
    // String for invalid message
    @State var invalidMessage: String = ""
    var body: some View {
        ZStack {
            // Background color
            Color(red: 167/255, green: 169/255, blue: 172/255)
                .edgesIgnoringSafeArea(.all)
            // Go to the home view if user is verified
            if homeView {
                HomeView(selectedUser: username)
            }
            else {
                // Stack for user to enter credentials
                VStack {
                    VStack(alignment: .leading) {
                        Text("Username")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                        TextField("Enter Username", text: $username)
                        Text("Password")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                        TextField("Enter Password", text: $password)
                    }
                    // Button to login
                    Button("Log in", action: {
                        if let user = users.first(where: { $0.name == username && $0.password == password }) {
                            //currentUser = user
                            print("Going to home view")
                            homeView.toggle()
                        }
                        else {
                            print("Incorresponding username or password")
                            invalidMessage = "Invalid username or password"
                        }
                    })
                    .font(.custom("Verdana", size: 24))
                    .foregroundColor(Color(red: 0/255, green: 80/255, blue: 136/255))
                    Text(invalidMessage)
                }
            }
        }
    }
}
// View if user selecrs sign up
struct signUpView: View {
    // Swift data variables
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [userRecord]
    // Text field variables
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    // String for invalid message
    @State var invalidMessage: String = ""
    // Boolean to toggle homeview
    @State var homeView: Bool = false
    var body: some View {
        ZStack {
            Color(red: 167/255, green: 169/255, blue: 172/255)
                .edgesIgnoringSafeArea(.all)
            if homeView {
                HomeView(selectedUser: username)
            }
            else {
                VStack {
                    VStack(alignment: .leading){
                        Text("Create a username")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                        TextField("Enter Username", text: $username)
                        Text("Create a password")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                        TextField("Enter Password", text: $password)
                        Text("Confirm password")
                            .font(.custom("Verdana", size: 24))
                            .bold()
                        TextField("Confirm Password", text: $confirmPassword)
                    }
                    Button("Log in", action: {
                        print("here")
                        if password != confirmPassword{
                            print("Passwords do not match")
                            invalidMessage = "Passwords do not match"
                            return
                        }
                        else {
                            print("here 2")
                            invalidMessage = ""
                            print(String(users.count))
                            let uRecord = userRecord(name: username, password: password)
                            modelContext.insert(uRecord)
                            do {
                                try modelContext.save()
                                print("Data saved!")
                                print(String(users.count))
                                homeView = true
                            } catch {
                                print("Error saving context: \(error)")
                            }
                        }
                        
                    })
                    .font(.custom("Verdana", size: 24))
                    .foregroundColor(Color(red: 0/255, green: 80/255, blue: 136/255))
                    Text(invalidMessage)
                }
            }
        }
    }
}
#Preview {
    ContentView()
}
