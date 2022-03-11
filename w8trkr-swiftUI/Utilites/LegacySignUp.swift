////
////  SignUpView.swift
////  w8trkr-ios
////
////  Created by Trevor Schmidt on 10/26/21.
////
//
//import SwiftUI
//
//struct SignUpView: View {
//    @ObservedObject var viewModel: AuthViewModel
//    @FocusState private var focusedField: Field?
//    
//    var body: some View {
//        ScrollView(showsIndicators: false) {
//            Image(systemName: "scalemass")
//                .font(.system(size: 150))
//                .padding(.top, 10)
//            
//            VStack(alignment: .leading) {
//                if !viewModel.signUpModel.username.isEmpty {
//                    Text("username")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .padding(.bottom, -7)
//                        .padding(.leading, 8)
//                }
//                FormattedTextField(prompt: "username", binding: $viewModel.signUpModel.username)
//                    .textInputAutocapitalization(.never)
//                    .disableAutocorrection(true)
//                    .submitLabel(.next)
//                    .focused($focusedField, equals: .username)
//                    .onSubmit {
//                        focusedField = .email
//                    }
//                    .animation(.default, value: viewModel.signUpModel.username)
//            }
//            .padding(.horizontal, 10)
//            .padding(.top, 20)
//            
//            if !viewModel.validUsername && viewModel.signUpModel.username.count > 0 {
//                withAnimation {
//                    HStack {
//                        Text("Username taken, please choose another.")
//                            .font(.caption)
//                            .foregroundColor(.red)
//                            .padding(.horizontal)
//                        Spacer()
//                    }
//                }
//            }
//            
//            VStack(alignment: .leading) {
//                if !viewModel.signUpModel.email.isEmpty {
//                    Text("email")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .padding(.bottom, -7)
//                        .padding(.leading, 8)
//                }
//                FormattedTextField(prompt: "email", binding: $viewModel.signUpModel.email)
//                    .textInputAutocapitalization(.never)
//                    .disableAutocorrection(true)
//                    .keyboardType(.emailAddress)
//                    .textContentType(.emailAddress)
//                    .submitLabel(.next)
//                    .focused($focusedField, equals: .email)
//                    .onSubmit {
//                        focusedField = .password
//                    }
//                    .animation(.default, value: viewModel.signUpModel.email)
//            }
//                .padding(.horizontal, 10)
//                .padding(.top, 8)
//            
//            
//            if !viewModel.validEmail && viewModel.signUpModel.email.count > 0 {
//                HStack {
//                    Text("Invalid Email")
//                        .font(.caption)
//                        .foregroundColor(.red)
//                        .padding(.horizontal)
//                    Spacer()
//                }
//            }
//            
//            VStack(alignment: .leading) {
//                if !viewModel.signUpModel.password.isEmpty {
//                    Text("password")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .padding(.bottom, -7)
//                        .padding(.leading, 8)
//                }
//                FormattedTextField(prompt: "password", binding: $viewModel.signUpModel.password, isSecure: true)
//                    .textInputAutocapitalization(.never)
//                    .disableAutocorrection(true)
//                    .keyboardType(.default)
//                    .textContentType(.newPassword)
//                    .submitLabel(.next)
//                    .focused($focusedField, equals: .password)
//                    .onSubmit {
//                        focusedField = nil
//                    }
//                    .animation(.default, value: viewModel.signUpModel.password)
//            }
//                .padding(.horizontal, 10)
//                .padding(.top, 8)
//            if !viewModel.validPassword && viewModel.signUpModel.password.count > 0 {
//                HStack {
//                    Text("Password must be 6 characters or longer")
//                        .font(.caption)
//                        .foregroundColor(.red)
//                        .padding(.horizontal)
//                    Spacer()
//                }
//            }
//            
//            NavigationLink {
//                UserInfoView(viewModel: viewModel)
//            } label: {
//                Text("CONTINUE")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(width: 220, height: 60)
//                    .background(!viewModel.canContinue ? Color.gray : AppViewModel.shared.accentColor)
//                    .cornerRadius(35)
//            }
//            .disabled(!viewModel.canContinue)
//            .padding(.vertical, 30)
//        }
//        .navigationTitle("Sign Up")
//        .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                Button(action: selectPreviousField) {
//                    Image(systemName: "chevron.up")
//                }
//                .disabled(!canSelectPreviousField)
//                Button(action: selectNextField) {
//                    Image(systemName: "chevron.down")
//                }
//                .disabled(!canSelectNextField)
//                Spacer()
//                
//                Button {
//                    focusedField = nil
//                } label: {
//                    Image(systemName: "keyboard.chevron.compact.down")
//                }
//            }
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                if viewModel.loading {
//                    ProgressView()
//                }
//            }
//        }
//    }
//}
//
//extension SignUpView {
//    // Focused Fields code
//    private enum Field: Int, Hashable {
//        case username, email, password
//    }
//    private func selectPreviousField() {
//        focusedField = focusedField.map {
//            Field(rawValue: $0.rawValue - 1)!
//        }
//    }
//    private func selectNextField() {
//        focusedField = focusedField.map {
//            Field(rawValue: $0.rawValue + 1)!
//        }
//    }
//    private var canSelectPreviousField: Bool {
//        if let currentFocusedField = focusedField {
//            return currentFocusedField.rawValue > 0
//        }
//        return false
//    }
//    private var canSelectNextField: Bool {
//        if let currentFocusedField = focusedField {
//            return currentFocusedField.rawValue < 2
//        }
//        return false
//    }
//}
//
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            SignUpView(viewModel: AuthViewModel())
//        }
//    }
//}
//
//
