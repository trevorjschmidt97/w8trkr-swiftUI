//
//  SearchModel.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/2/21.
//

import Foundation

struct SearchModel {
    var users: [SearchUser] = []
}

struct SearchUser: Identifiable, Codable {
    var id: String {
        userId
    }
    
    var userId: String = ""
    var username: String = ""
    var email: String = ""
    var profilePicUrl: String? = nil
    
    var searchString: String {
        return userId.lowercased() + username.lowercased()// + email.lowercased()
    }
}
