//
//  ContentView.swift
//  w8trkr-swiftUI
//
//  Created by Trevor Schmidt on 1/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = AppViewModel.shared
    
    var body: some View {
        if viewModel.isSignedIn {
            TabView {
                
                NavigationView {
                    ProfileView(userId: FirebaseAuthService.shared.getUserId() ?? "")
                }
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                
                NavigationView {
                    AddWeightView()
                }
                .tabItem {
                    Label("New Weight", systemImage: "plus")
                }
                
                NavigationView {
                    SearchView()
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
            }
            .onAppear {
                viewModel.pullUserInfo()
            }
        } else {
            NavigationView {
                SignInView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
