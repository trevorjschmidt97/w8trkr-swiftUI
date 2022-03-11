//
//  AuthViewModel.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/26/21.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    
    @Published var signInModel = SignInModel()
    @Published var signUpModel = SignUpModel()
    @Published var usernameSet: Set<String> = []
    @Published var loading = false
    
    var usernameTaken: Bool { usernameSet.contains(signUpModel.username) }
    var validUsername: Bool { !(signUpModel.username.count < 4) }
    var validEmail: Bool { signUpModel.email.validEmail() }
    var validPassword: Bool { signUpModel.password.count > 5 }
    var validCurrentWeight: Bool {
        if let doubleVal = Double(signUpModel.currentWeight), doubleVal > 50 && doubleVal < 1000 {
            return true
        }
        return false
    }
    var validGoalWeight: Bool {
        if let doubleVal = Double(signUpModel.goalWeight), doubleVal > 50 && doubleVal < 1000 {
            return true
        }
        return false
    }
    var canSignIn: Bool { signInModel.email.validEmail() && signInModel.password.count > 6 }
    var canSignUp: Bool { validUsername && validEmail && validPassword && validCurrentWeight && validGoalWeight }
    var canContinue: Bool { validUsername && validEmail && validPassword }
    
    func onAppear() {
        loading = true
        FirebaseDbService.shared.pullUsernames { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.loading = false
                switch result {
                case .success(let usernames):
                    self.usernameSet = usernames
                case .failure(let error):
                    print(error.localizedDescription)
                    AppViewModel.shared.showAlert(title: "Oops", message: "Unable to pull usernames")
                }
            }
        }
    }
    
    func signIn() {
        loading = true
        FirebaseAuthService.shared.signIn(email: signInModel.email, password: signInModel.password) { [weak self] result in
            self?.loading = false
            switch result {
            case .success:
                AppViewModel.shared.isSignedIn = true
                AppViewModel.shared.showSuccess(title: "Logged In!")
            case .failure(let error):
                AppViewModel.shared.showAlert(title: "Oops", message: error.localizedDescription)
            }
        }
    }
    
    func forgotPassword() {
        loading = true
        FirebaseAuthService.shared.forgotPassword(email: signInModel.email) { [weak self] result in
            self?.loading = false
            switch result {
            case .success(_):
                print("success")
                AppViewModel.shared.showSuccess(title: "Email Sent!")
            case .failure(_):
                AppViewModel.shared.showAlert(title: "Oops", message: "Cannot Send Password Reset Email")
            }
        }
    }
    
    func signUp() {
        guard let doubleCurrentWeight = Double(signUpModel.currentWeight),
              let doubleGoalWeight = Double(signUpModel.goalWeight) else {
                  AppViewModel.shared.showAlert(title: "Oops", message: "Please enter valid weights")
                  return
              }
        
        loading = true
        FirebaseAuthService.shared.signUp(email: signUpModel.email, password: signUpModel.password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let userId):
                    FirebaseDbService.shared.register(userId: userId,
                                                      username: self.signUpModel.username,
                                                      email: self.signUpModel.email,
                                                      currentWeight: doubleCurrentWeight,
                                                      goalWeight: doubleGoalWeight)
                    AppViewModel.shared.showSuccess(title: "Welcome!")
                    AppViewModel.shared.isSignedIn = true
                case .failure(let error):
                    AppViewModel.shared.showAlert(title: "Oops", message: error.localizedDescription)
                }
                self.loading = false
            }
        }
    }
}
