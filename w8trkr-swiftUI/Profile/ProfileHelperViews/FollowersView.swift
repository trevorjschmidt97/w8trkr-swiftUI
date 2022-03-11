//
//  FollowersView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/3/21.
//

import SwiftUI

struct FollowersView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var profileState: ProfileState
    
    var body: some View {
        if profileState != .editProfile && viewModel.model.followers == nil ||
            viewModel.model.followers == nil && viewModel.model.pendingFollowers == nil {
            if let userId = FirebaseAuthService.shared.getUserId() {
                GeometryReader { proxy in
                    Text("\(userId == viewModel.model.userId ? "You have" : viewModel.model.username + " has") no followers")
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                        .foregroundColor(.secondary)
                }
            }
        } else {
            List {
                if profileState == .editProfile {
                    if viewModel.model.pendingFollowersList.count > 0 {
                        Section("Requested Followers") {
                            ForEach(viewModel.model.pendingFollowersList, id:\.userId) { pendingFollower in
                                
                                HStack {
                                    ProfileImageView(username: pendingFollower.username, profilePicUrl: pendingFollower.profilePicUrl, size: 60)
                                    Text("\(pendingFollower.username)")
                                    Spacer()
                                    
                                    Button { } label: {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.green)
                                    }
                                    .onTapGesture {
                                        viewModel.acceptPendingFollower(otherUserId: pendingFollower.userId,
                                                                        otherUsername: pendingFollower.username,
                                                                        otherProfilePicUrl: pendingFollower.profilePicUrl)
                                    }
                                    
                                    Button { } label: {
                                        Image(systemName: "x.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.red)
                                    }
                                    .padding(.trailing, 12)
                                    .onTapGesture {
                                        viewModel.rejectPendingFollower(otherUserId: pendingFollower.userId)
                                    }
                                }
                                .background(NavigationLink("") {
                                    ProfileView(userId: pendingFollower.userId)
                                        .navigationBarTitleDisplayMode(.inline) })
                                
                            }
                        }
                    }
                }
                
                if viewModel.model.followersList.count > 0 {
                    Section("Followers") {
                        ForEach(viewModel.model.followersList, id:\.userId) { follower in
                            NavigationLink(destination:
                                            ProfileView(userId: follower.userId)
                                            .navigationBarTitleDisplayMode(.inline)
                            ) {
                                HStack {
                                    ProfileImageView(username: follower.username,
                                                     profilePicUrl: follower.profilePicUrl,
                                                     size: 60)
                                    
                                    VStack(alignment:.leading) {
                                        Text("\(follower.username)")
                                        if profileState != .editProfile && AppViewModel.shared.model.followersSet.contains(follower.userId) {
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

//struct FollowersView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowersView()
//    }
//}
