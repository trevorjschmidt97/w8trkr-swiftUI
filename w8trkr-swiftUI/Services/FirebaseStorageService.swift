//
//  FirebaseStorageService.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/2/21.
//

import Foundation
import FirebaseStorage

struct FirebaseStorageService {
    static let shared = FirebaseStorageService()
    
    private init() { }
    
    private struct Key {
        static let userProfilePics = "userProfilePics"
    }
    
    private let rootRef = Storage.storage().reference()
    
    func updateProfilePic(userId: String, imageData: Data, completion: @escaping (Result<String,Error>) -> Void) {
        rootRef.child(Key.userProfilePics).child(userId + ".jpg").putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                completion(.failure(error))
                print("Error at Function: \(#function), line: \(#line)")
                return
            }
            
            rootRef.child(Key.userProfilePics).child(userId + ".jpg").downloadURL { url, error in
                guard error == nil else {
                    completion(.failure(DbError.noData))
                    print("Error at Function: \(#function), line: \(#line)")
                    return
                }
                guard let url = url else {
                    completion(.failure(DbError.noData))
                    print("Error at Function: \(#function), line: \(#line)")
                    return }
                completion(.success(url.absoluteString))
            }
        }
    }
}
