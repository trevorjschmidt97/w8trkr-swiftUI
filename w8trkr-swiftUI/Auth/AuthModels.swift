//
//  AuthModels.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/26/21.
//

import Foundation

struct SignInModel {
    var email = ""
    var password = ""
}

struct SignUpModel {
    var username = ""
    var email = ""
    var phoneNumber = ""
    var password = ""
    var currentWeight = ""
    var date = Date()
    var goalWeight = ""
    var age = ""
    var height = ""
}
