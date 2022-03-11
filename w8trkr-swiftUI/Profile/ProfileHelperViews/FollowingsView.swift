//
//  FollowingsView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/3/21.
//

import SwiftUI

struct FollowingsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var followingState: ProfileState
    
    var body: some View {
        if followingState != .editProfile && viewModel.model.followings == nil ||
            viewModel.model.followings == nil && viewModel.model.pendingFollowings == nil {
            GeometryReader { proxy in
                Text("\(followingState == .editProfile ? "You are" : viewModel.model.username + " is") not following anyone")
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .foregroundColor(.secondary)
            }
        } else {
            List {
                if followingState == .editProfile {
                    if viewModel.model.pendingRequestsList.count > 0 {
                        Section("Pending Requests") {
                            ForEach(viewModel.model.pendingRequestsList, id:\.userId) { request in
                             
                                
                                HStack {
                                    ProfileImageView(username: request.username, profilePicUrl: request.profilePicUrl, size: 60)
                                    Text("\(request.username)")
                                    Spacer()
                                    
                                    Button(action: { }) {
                                        Image(systemName: "x.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.red)
                                    }
                                    .padding(.trailing, 12)
                                    .onTapGesture {
                                        viewModel.cancelRequestFromSelfProfile(otherUserId: request.userId)
                                    }
                                }
                                .background(NavigationLink("") { ProfileView(userId: request.userId).navigationBarTitleDisplayMode(.inline) })
                                
                                
                            }
                        }
                    }
                }
                
                if viewModel.model.followingsList.count > 0 {
                    Section("Following") {
                        ForEach(viewModel.model.followingsList, id:\.userId) { following in
                            NavigationLink(destination:
                                            ProfileView(userId: following.userId)
                                            .navigationBarTitleDisplayMode(.inline)
                            ) {
                                HStack {
                                    ProfileImageView(username: following.username, profilePicUrl: following.profilePicUrl, size: 60)
                                    
                                    VStack(alignment:.leading) {
                                        Text("\(following.username)")
                                        if followingState != .editProfile && AppViewModel.shared.model.followersSet.contains(following.userId) {
                                            Text("follows you")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct FollowingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowingsView(viewModel: ProfileViewModel(userId: ""))
//    }
//}
