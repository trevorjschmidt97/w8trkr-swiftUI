//
//  SignUpView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/26/21.
//

import SwiftUI
import Combine // for Just

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?

    var body: some View {
        Form {
            // Login Info
            Section("Login info") {
                // Username
                HStack {
                    Text("Username")
                        .foregroundColor(viewModel.signUpModel.username.count == 0 ? .primary :
                                            viewModel.validUsername && !viewModel.usernameTaken ? .green : .red)
                    Spacer()
                    TextField("username", text: $viewModel.signUpModel.username, prompt: nil)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.alphabet)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .username)
                        .onSubmit {
                            focusedField = .email
                        }
                }
                if viewModel.signUpModel.username.count > 0 && viewModel.usernameTaken {
                    Text("Username taken, please choose another")
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.trailing)
                }
                
                // Email
                HStack {
                    Text("Email")
                        .foregroundColor(viewModel.signUpModel.email.count == 0 ? .primary :
                            viewModel.validEmail ? .green : .red)
                    Spacer()
                    TextField("email", text: $viewModel.signUpModel.email, prompt: nil)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .email)
                        .onSubmit {
                            focusedField = .password
                        }
                }
                
                // Password
                HStack {
                    Text("Password")
                        .foregroundColor(viewModel.signUpModel.password.count == 0 ? .primary :
                                            !viewModel.validPassword ? .red : .green)
                    Spacer()
                    SecureField("password", text: $viewModel.signUpModel.password, prompt: nil)
                        .multilineTextAlignment(.trailing)
                        .animation(Animation.default, value: viewModel.signUpModel.password)
                        .keyboardType(.default)
                        .textContentType(.newPassword)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password)
                        .onSubmit {
                            focusedField = .currentWeight
                        }
                }
            }
                   
            // Weight
            Section("Weight") {
                // Current Weight
                HStack {
                    Text("Current Weight")
                        .foregroundColor(viewModel.signUpModel.currentWeight.count == 0 ? .primary : !viewModel.validCurrentWeight ? .red : .green)
                    Spacer()
                    TextField("weight", text: $viewModel.signUpModel.currentWeight, prompt: nil)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onReceive(Just(viewModel.signUpModel.currentWeight)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                viewModel.signUpModel.currentWeight = filtered
                            }
                        }
                        .focused($focusedField, equals: .currentWeight)
                        .onSubmit {
                            focusedField = .goalWeight
                        }
                }
                
                // Goal Weight
                HStack {
                    Text("Goal Weight")
                        .foregroundColor(viewModel.signUpModel.goalWeight.count == 0 ? .primary : !viewModel.validGoalWeight ? .red : .green)
                    Spacer()
                    TextField("weight", text: $viewModel.signUpModel.goalWeight, prompt: nil)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onReceive(Just(viewModel.signUpModel.goalWeight)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                viewModel.signUpModel.goalWeight = filtered
                            }
                        }
                        .focused($focusedField, equals: .goalWeight)
                        .onSubmit {
                            focusedField = nil
                        }
                }
            }
    
            // Sign Up Button
            HStack {
                Spacer()
                Button("Sign Up") {
                    viewModel.signUp()
                }
                    .disabled(!viewModel.canSignUp)
                    .tint(viewModel.canSignUp ? .green : .red)
                Spacer()
            }
        }
            .navigationTitle("Sign Up")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: selectPreviousField) {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(!canSelectPreviousField)
                    Button(action: selectNextField) {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(!canSelectNextField)
                    Spacer()
                    
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if viewModel.loading {
                        ProgressView()
                    }
                }
            }
    }
}

extension SignUpView {
    // Focused Fields code
    private enum Field: Int, Hashable {
        case username, email, password, currentWeight, goalWeight
    }
    private func selectPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1)!
        }
    }
    private func selectNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1)!
        }
    }
    private var canSelectPreviousField: Bool {
        if let currentFocusedField = focusedField {
            return currentFocusedField.rawValue > 0
        }
        return false
    }
    private var canSelectNextField: Bool {
        if let currentFocusedField = focusedField {
            return currentFocusedField.rawValue < 4
        }
        return false
    }
}

struct UserInfoView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            SignUpView(viewModel: AuthViewModel())
        }
            .previewDevice("iPhone 13")
            .navigationViewStyle(StackNavigationViewStyle())
            .previewDisplayName("iPhone 13")
        
        NavigationView {
            SignUpView(viewModel: AuthViewModel())
        }
        .preferredColorScheme(.dark)
            .previewDevice("iPhone 13")
            .navigationViewStyle(StackNavigationViewStyle())
            .previewDisplayName("iPhone 13")
        
        NavigationView {
            SignUpView(viewModel: AuthViewModel())
        }
            .previewDevice("iPad Pro (11-inch) (3rd generation)")
            .navigationViewStyle(StackNavigationViewStyle())
            .previewDisplayName("iPad Pro (11-inch)")
    }
}
