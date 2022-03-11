//
//  AppViewModel.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/26/21.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    
    static var shared = AppViewModel()
    private init() { }
    
    @Published var model = AppModel()
    @Published var loading = false
    
    // Color
    @AppStorage("accentColorString") var accentColorString = "blue" {
        willSet {
            UIApplication.shared.setAlternateIconName(newValue) { error in
                guard error == nil else {
                    print("Error changing app icon")
                    return
                }
                print("Icon updated")
            }
        }
    }
    var accentColor: Color {
        switch accentColorString {
        case "blue": return Color.blue
        case "brown": return Color.brown
        case "cyan": return Color.cyan
        case "green": return Color.green
        case "orange": return Color.orange
        case "purple": return Color.purple
        case "red": return Color.red
        case "yellow": return Color.yellow
        default: return Color.green
        }
    }
    var accentColorHex: String {
        switch accentColorString {
        case "blue": return "#007aff"
        case "brown": return "#a2845e"
        case "cyan": return "#32ade6"
        case "green": return "#34c759"
        case "orange": return "#ff9500"
        case "purple": return "#af52de"
        case "red": return "#ff3b30"
        case "yellow": return "#ffcc00"
        default: return "#34c759"
        }
    }
    
    // Auth
    @Published var isSignedIn = false
    
    // Alert
    @Published var alertShown = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var successShown = false
    var successTitle = ""
    
    func checkSignIn() {
        isSignedIn = FirebaseAuthService.shared.checkSignIn()
    }
    
    func pullUserInfo() {
        loading = true
        if let userId = FirebaseAuthService.shared.getUserId() {
            FirebaseDbService.shared.pullUserInfo(uniqueUserId: userId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let appModel):
                        withAnimation {
                            self?.model = appModel
                        }
                    case .failure(_):
                        self?.showAlert(title: "Oops", message: "Unable to pull all info")
                    }
                    self?.loading = false
                }
            }
        }
    }
    
    func showSuccess(title: String) {
        successTitle = title
        successShown = true
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1.0)
    }
    
    func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        alertShown = true
    }
    
}
