//
//  AppModels.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/26/21.
//

import Foundation

struct AppModel {
    var followersSet: Set<String> = []
    var followingsSet: Set<String> = []
    var pendingFollowersSet: Set<String> = []
    var pendingRequestsSet: Set<String> = []
}
