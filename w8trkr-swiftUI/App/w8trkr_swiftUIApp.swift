//
//  w8trkr_swiftUIApp.swift
//  w8trkr-swiftUI
//
//  Created by Trevor Schmidt on 1/9/22.
//

import SwiftUI
import Firebase
import AlertToast

public func printError(file: String = #file, function: String = #function, line: Int = #line ) {
    print("Error in\nfile: \(file)\nfunction: \(function)\nline: \(line)")
}

@main
struct w8trkr_swiftUIApp: App {
    
    @StateObject var viewModel = AppViewModel.shared
    
    init() {
        FirebaseApp.configure()
        UINavigationBar.appearance().tintColor = UIColor(AppViewModel.shared.accentColor)
        UITabBar.appearance().backgroundColor = .systemBackground
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .tint(AppViewModel.shared.accentColor)
                    .accentColor(AppViewModel.shared.accentColor)
                    .onAppear {
                        viewModel.checkSignIn()
                    }
                    .toast(isPresenting: $viewModel.successShown, duration: 2.5, tapToDismiss: true, offsetY: 0.0, alert: {
                        AlertToast(displayMode: .hud,
                                   type: .complete(.green),
                                   title: viewModel.successTitle)
                    }, onTap: nil, completion: nil)
                    .toast(isPresenting: $viewModel.alertShown) {
                        AlertToast(displayMode: .alert,
                                   type: .error(.red),
                                   title: viewModel.alertTitle,
                                   subTitle: viewModel.alertMessage,
                                   style: nil)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                
                if viewModel.loading {
                    ZStack {
                        Color(.white)
                            .opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView("Loading")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(.systemBackground))
                            )
                            .shadow(radius: 10)
                    }
                }
            }
        }
    }
}
