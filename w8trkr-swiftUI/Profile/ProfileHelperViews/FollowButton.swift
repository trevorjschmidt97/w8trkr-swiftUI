//
//  FollowButton.swift
//  FollowButton
//
//  Created by Trevor Schmidt on 8/20/21.
//

import SwiftUI

struct FollowButton: View {
    var viewModel: ProfileViewModel
    var profileState: ProfileState
    @Binding var alertPresented: Bool
    var appViewModel = AppViewModel.shared
    
    var body: some View {
        Button {
            switch profileState {
            case .editProfile:
                alertPresented = true
            case .following:
                alertPresented = true
            case .followBack:
                viewModel.followButtonPressed()
            case .follow:
                viewModel.followButtonPressed()
            case .requested:
                alertPresented = true
            }
        } label: {
            HStack {
                Spacer()
                switch profileState {
                case .editProfile:
                    Text("Settings")
                case .following:
                    Text("Following")
                case .followBack:
                    Text("Follow Back")
                case .requested:
                    Text("Requested")
                case .follow:
                    Text("Follow")
                }
                Spacer()
            }
                .font(.callout)
                .foregroundColor(.white)
                .padding()
                .frame(height: 30)
                .background(appViewModel.accentColor)
                .cornerRadius(5)
        }
    }
}
