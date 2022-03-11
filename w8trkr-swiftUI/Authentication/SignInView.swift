//
//  SignInView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/26/21.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel = AuthViewModel()
    @FocusState private var focusedField: Field?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading) {
                if !viewModel.signInModel.email.isEmpty {
                    Text("email")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, -7)
                        .padding(.leading, 8)
                }
                TextField("email", text: $viewModel.signInModel.email, prompt: nil)
                    .font(.caption)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
                    .textContentType(.username)
                    .submitLabel(.next)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }
                    .animation(.default, value: viewModel.signInModel.email)
                
                if !viewModel.signInModel.email.isEmpty {
                    HStack {
                        Spacer()
                        Button("Forgot password?") {
                            viewModel.forgotPassword()
                        }
                        .font(.caption)
                    }
                }
            }
                .padding(.horizontal, 10)
                .padding(.top, 60)
            
            
            VStack(alignment: .leading) {
                if !viewModel.signInModel.password.isEmpty {
                    Text("password")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, -7)
                        .padding(.leading, 8)
                }
                SecureField("password", text: $viewModel.signInModel.password, prompt: nil)
                    .font(.caption)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .textContentType(.password)
                    .submitLabel(.go)
                    .focused($focusedField, equals: .password)
                    .animation(.default, value: viewModel.signInModel.password)
                    .onSubmit {
                        focusedField = nil
                        viewModel.signIn()
                    }
            }
                .padding(.top, 8)
                .padding(.horizontal, 10)
            
            
            Button {
                viewModel.signIn()
            } label: {
                Text("SIGN IN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(viewModel.canSignIn ? AppViewModel.shared.accentColor : Color.gray)
                    .cornerRadius(35)
            }
                .padding(.top, 30)
                .disabled(!viewModel.canSignIn)
            
            NavigationLink("Don't Have An Account?", destination: SignUpView(viewModel: viewModel))
                .font(.caption)
                .padding()
        }
            .onAppear {
                viewModel.onAppear()
            }
            .navigationTitle("Welcome")
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

extension SignInView {
    // Focused Fields code
    private enum Field: Int, Hashable {
        case email, password
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
            return currentFocusedField.rawValue < 1
        }
        return false
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
        }
    }
}
