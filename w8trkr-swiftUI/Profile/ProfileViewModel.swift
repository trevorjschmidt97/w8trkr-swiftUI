//
//  ProfileViewModel.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/31/21.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {

    @Published var model = ProfileModel()
    var userId: String = ""
    var inputImage: UIImage?
    var loading = true
    
    init(userId: String, username:String="") {
        self.userId = userId
        if username != "" {
            model.username = username
        }
        if userId == FirebaseAuthService.shared.getUserId() {
            withAnimation {
                model.username = UserDefaults.standard.string(forKey: "username") ?? ""
                model.profilePicUrl = UserDefaults.standard.string(forKey: "profilePicUrl")
            }
        }
        
        FirebaseDbService.shared.pullProfileInfo(of: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileModel):
                    if userId == FirebaseAuthService.shared.getUserId() {
                        UserDefaults.standard.set(profileModel.username, forKey: "username")
                        UserDefaults.standard.set(profileModel.profilePicUrl, forKey: "profilePicUrl")
                    }
                    withAnimation {
                        self?.model = profileModel
                    }
                case .failure(let error):
                    printError()
                    print(error.localizedDescription)
                }
                self?.loading = false
            }
        }
    }
    
    func followButtonPressed() {
        if model.isPrivate {
            request()
        } else {
            follow()
        }
    }
    
    func follow() {
        guard let selfUserId = FirebaseAuthService.shared.getUserId() else { return }
        FirebaseDbService.shared.follow(selfUserId: selfUserId,
                                        otherUserId: model.userId,
                                        otherUsername: model.username,
                                        otherProfilePicUrl: model.profilePicUrl)
        AppViewModel.shared.model.followingsSet.insert(model.userId)
        AppViewModel.shared.showSuccess(title: "Follow Successful")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func request() {
        guard let selfUserId = FirebaseAuthService.shared.getUserId() else { return }
        FirebaseDbService.shared.request(selfUserId: selfUserId,
                                         otherUserId: model.userId,
                                         otherUsername: model.username,
                                         otherProfilePicUrl: model.profilePicUrl)
        AppViewModel.shared.model.pendingRequestsSet.insert(model.userId)
        AppViewModel.shared.showSuccess(title: "Follow Request Sent")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func unFollow() {
        guard let selfUserId = FirebaseAuthService.shared.getUserId() else { return }
        FirebaseDbService.shared.unFollow(selfUserId: selfUserId, otherUserId: userId)
        AppViewModel.shared.model.followingsSet.remove(model.userId)
        AppViewModel.shared.showSuccess(title: "Unfollow Successful")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func cancelRequestFromOtherProfile() {
        guard let selfUserId = FirebaseAuthService.shared.getUserId() else { return }
        FirebaseDbService.shared.cancelFollowRequest(from: selfUserId, to: userId)
        AppViewModel.shared.model.pendingRequestsSet.remove(userId)
        AppViewModel.shared.showSuccess(title: "Follow Request Cancelled")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func cancelRequestFromSelfProfile(otherUserId: String) {
        FirebaseDbService.shared.cancelFollowRequest(from: userId, to: otherUserId)
        AppViewModel.shared.model.pendingRequestsSet.remove(otherUserId)
        AppViewModel.shared.showSuccess(title: "Follow Request Cancelled")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func acceptPendingFollower(otherUserId: String, otherUsername: String, otherProfilePicUrl: String?) {
        FirebaseDbService.shared.acceptPendingFollower(selfUserId: userId, selfUsername: model.username, selfProfilePic: model.profilePicUrl, otherUserId: otherUserId, otherUsername: otherUsername, otherProfilePicUrl: otherProfilePicUrl)
        AppViewModel.shared.model.pendingFollowersSet.remove(otherUserId)
        AppViewModel.shared.model.followersSet.insert(otherUserId)
        AppViewModel.shared.showSuccess(title: "Follower Accepted")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func rejectPendingFollower(otherUserId: String) {
        FirebaseDbService.shared.rejectPendingFollower(selfUserId: userId, otherUserId: otherUserId)
        AppViewModel.shared.model.pendingFollowersSet.remove(otherUserId)
        AppViewModel.shared.showSuccess(title: "Follower Rejected")
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func logOutButtonPressed() {
        AppViewModel.shared.isSignedIn = FirebaseAuthService.shared.signOut()
        AppViewModel.shared.showSuccess(title: "Logged Out")
    }
    
    func changePrivacy() {
        FirebaseDbService.shared.updatePrivacy(userId: model.userId, newPrivacy: !model.isPrivate)
        AppViewModel.shared.showSuccess(title: "Privacy Updated")
    }
    
    func updateProfilePicture() {
        guard let image = inputImage else {
            print("no image selected")
            return
        }
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            print("error getting image data")
            return
        }
        
        FirebaseStorageService.shared.updateProfilePic(userId: model.userId, imageData: imageData) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let urlString):
                    FirebaseDbService.shared.updateProfilePicUrl(userId: self.model.userId, profilePicUrl: urlString)
                    AppViewModel.shared.showSuccess(title: "Updated Profile Pic")
                case .failure(let error):
                    print("Error at Function: \(#function), line: \(#line)")
                    print(error.localizedDescription)
                    AppViewModel.shared.showAlert(title: "Oops", message: "Unable To Update Profile Pic")
                }
            }
        }
    }
    
    func deleteWeighIn(weighIn: Weight) {
        FirebaseDbService.shared.deleteWeight(userId: model.userId, dateTime: weighIn.dateTime)
        AppViewModel.shared.showSuccess(title: "Weight Deleted")
    }
    
    func updateWeighIn(dateTime: String, weight: Double, notes: String) {
        FirebaseDbService.shared.updateWeight(userId: model.userId, dateTime: dateTime, weight: weight, notes: notes)
        AppViewModel.shared.showSuccess(title: "Weight Updated")
    }
    
    
}
