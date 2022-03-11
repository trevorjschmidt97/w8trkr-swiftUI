//
//  ProfileView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/31/21.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    var userId: String

    init(userId: String, username:String="") {
        self.userId = userId
        viewModel = ProfileViewModel(userId: userId, username: username)
    }
    
    @ObservedObject var viewModel: ProfileViewModel
    
    @State private var contentState = ContentState.weights
    @State private var alertIsPresented: Bool = false
    @State private var showingImagePicker = false
    @State private var showingPrivacyAlert = false
    @State private var showingColorPicker = false
    
    private var profileState: ProfileState {
        guard let userSelfId = FirebaseAuthService.shared.getUserId() else { return .editProfile }
        if userId == userSelfId {
            return .editProfile
        } else if AppViewModel.shared.model.followingsSet.contains(userId) {
            return .following
        } else if AppViewModel.shared.model.pendingRequestsSet.contains(userId) {
            return .requested
        } else if AppViewModel.shared.model.followersSet.contains(userId) {
            return .followBack
        } else {
            return .follow
        }
    }
    
    var body: some View {
        VStack {
            // Stats
            HStack {
                ProfileImageView(username: viewModel.model.username, profilePicUrl: viewModel.model.profilePicUrl, size: 90)
                    .padding(.vertical)
                
                VStack {
                    StatsView(contentState: $contentState,
                              weightsCount: viewModel.model.weightsList.count,
                              followersCount: viewModel.model.followersList.count,
                              followingsCount: viewModel.model.followingsList.count)
                    
                    FollowButton(viewModel: viewModel, profileState: profileState, alertPresented: $alertIsPresented)
                }
            }
                .padding(.horizontal)
            
            // Content View
            if let selfUserId = FirebaseAuthService.shared.getUserId(), selfUserId == userId || AppViewModel.shared.model.followingsSet.contains(userId) || !viewModel.model.isPrivate {

                ZStack {
                    VStack {
                        Text("Goal Weight: \(viewModel.model.goalWeight.formatted())")
                            .font(.subheadline)
                            .bold()
                        WeightContentView(viewModel: viewModel)
                    }
                    .opacity(contentState == .weights ? 1 : 0)
                FollowersView(viewModel: viewModel, profileState: profileState)
                    .opacity(contentState == .followers ? 1 : 0)
                FollowingsView(viewModel: viewModel, followingState: profileState)
                    .opacity(contentState == .followings ? 1 : 0)
                }
                
            } else {
                VStack {
                    Spacer()
                    Text("\(viewModel.model.username) Is Private")
                    Spacer()
                }
            }
            
        }
            .navigationTitle(viewModel.model.username)
            .confirmationDialog("", isPresented: $alertIsPresented) {
                ConfirmationDialogView(viewModel: viewModel,
                                       profileState: profileState,
                                       showingImagePicker: $showingImagePicker,
                                       showingPrivacyAlert: $showingPrivacyAlert,
                                       showingColorPicker: $showingColorPicker)
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: {
                viewModel.updateProfilePicture()
            }, content: {
                ImagePicker(image: $viewModel.inputImage)
            })
            .alert(isPresented: $showingPrivacyAlert) {
                Alert(title: Text("Change Privacy Settings"),
                      message: Text("You are currently \(viewModel.model.isPrivate ? "private" : "public"), do you wish to change?"),
                      primaryButton: .default(Text("Switch to \(!viewModel.model.isPrivate ? "Private" : "Public")")) { viewModel.changePrivacy() },
                      secondaryButton: .cancel()
                      )
            }
            .confirmationDialog("Change Color", isPresented: $showingColorPicker) {
                ChangeAppColorView(alertIsPresented: $alertIsPresented)
            }
    }
}
