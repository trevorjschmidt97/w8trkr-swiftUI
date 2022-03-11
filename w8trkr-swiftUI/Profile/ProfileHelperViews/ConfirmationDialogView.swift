//
//  ConfirmationDialogView.swift
//  ConfirmationDialogView
//
//  Created by Trevor Schmidt on 8/26/21.
//

import SwiftUI

struct ConfirmationDialogView: View {
    var viewModel: ProfileViewModel
    var profileState: ProfileState
    @Binding var showingImagePicker: Bool
    @Binding var showingPrivacyAlert: Bool
    @Binding var showingColorPicker: Bool
    
    var body: some View {
        Group {
            switch profileState {
            case .editProfile:
                Button("Change App Color") {
                    showingColorPicker = true
                }
                Button("Update Profile Picture") {
                    showingImagePicker = true
                }
                Button("Change Privacy Settings") {
                    showingPrivacyAlert = true
                }
                Button("Sign Out") {
                    viewModel.logOutButtonPressed()
                }
            case .following:
                Button("Unfollow \(viewModel.model.username)") {
                    viewModel.unFollow()
                }
            case .requested:
                Button("Cancel Follow Request") {
                    viewModel.cancelRequestFromOtherProfile()
                }
            default:
                EmptyView()
            }
            Button("Cancel", role: .cancel) {}
        }
            .accentColor(AppViewModel.shared.accentColor)
            .tint(AppViewModel.shared.accentColor)
    }
}


