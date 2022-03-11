//
//  SearchView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/31/21.
//

import SwiftUI

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @State private var searchText = ""
    
    var filteredUsers: [SearchUser] {
        if searchText.count == 0 {
            return viewModel.model.users.sorted { su1, su2 in
                su1.username < su2.username
            }
        } else {
            return viewModel.model.users.filter { user in
                user.searchString.contains(searchText.lowercased())
            }.sorted { su1, su2 in
                su1.username < su2.username
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredUsers) { user in
                
                NavigationLink {
                    ProfileView(userId: user.userId, username: user.username)
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    HStack {
                        ProfileImageView(username: user.username, profilePicUrl: user.profilePicUrl, size: 60)
                        
                        VStack(alignment: .leading) {
                            Text("\(user.username)")
                            if let selfUserId = FirebaseAuthService.shared.getUserId(), selfUserId == user.userId {
                                Text("you")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else if AppViewModel.shared.model.pendingRequestsSet.contains(user.userId) {
                                Text("requested")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else if AppViewModel.shared.model.followingsSet.contains(user.userId) {
                                Text("following")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else if AppViewModel.shared.model.followersSet.contains(user.userId) {
                                Text("follows you")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }

            }
        }
//            .searchable(text: $searchText)
            .searchable(text: $searchText, prompt: "find by username")
            .disableAutocorrection(true)
            .navigationTitle("Search")
            .onAppear {
                viewModel.onAppear()
            }
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    if viewModel.loading {
//                        ProgressView()
//                    }
//                }
//            }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
