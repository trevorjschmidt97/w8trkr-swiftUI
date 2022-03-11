////
////  FirebaseFunctionsService.swift
////  w8trkr-ios
////
////  Created by Trevor Schmidt on 11/22/21.
////
//
//import Foundation
//import FirebaseFunctions
//
//struct FirebaseFunctionsService {
//    static var shared = FirebaseFunctionsService()
//    private init() { }
//
//    lazy var functions = Functions.functions()
//
//    mutating func sendNotification() {
//        let data = [
//            "title": "Hey",
//            "message": "Message",
//            "tokens": "lsakdjflsdkjfkldjflkdjflj"
//        ]
//
//        functions.httpsCallable("sendNotification").call(data) { result, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            guard let result = result else {
//                return
//            }
//            print(result.data)
//
//
//        }
//    }
//
//}
//
