//
//  FirebaseAuthService.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/26/21.
//

import Foundation
import FirebaseAuth

enum AuthError: Error {
    case signInError
    case signUpError
}

struct FirebaseAuthService {
    static var shared = FirebaseAuthService()
    
    private init() { }
    
    private var auth = Auth.auth()
    
    func checkSignIn() -> Bool {
        auth.currentUser != nil
    }
    
    func getUserId() -> String? {
        auth.currentUser?.uid
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if result != nil {
                completion(.success)
            } else {
                completion(.failure(AuthError.signInError))
            }
            return
        }
    }
    
    func forgotPassword(email: String, completion: @escaping (Result<String,Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(email))
            }
            return
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let result = result {
                completion(.success(result.user.uid))
            } else {
                completion(.failure(AuthError.signUpError))
            }
            return
        }
    }
    
    func signOut() -> Bool {
        if (try? auth.signOut()) == nil {
            UserDefaults.standard.set("", forKey: "username")
            UserDefaults.standard.set("", forKey: "profilePicUrl")
            return true
        }
        return false
    }
    
//    func deleteAccount() {
//        auth.currentUser?.delete(completion: { error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                
//            }
//        })
//    }
}

extension Result where Success == Void {
    public static var success: Result { .success(()) }
}
