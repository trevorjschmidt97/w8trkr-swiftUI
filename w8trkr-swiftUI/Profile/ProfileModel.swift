//
//  ProfileModel.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/31/21.
//

import Foundation

enum ContentState {
    case weights
    case followers
    case followings
}

enum ProfileState {
    case editProfile
    case following
    case followBack
    case follow
    case requested
}

struct ProfileModel: Codable {
    var userId: String = ""
    var username: String = ""
    var goalWeight: Double = 0.0
    var isPrivate: Bool = true
    var profilePicUrl: String?
    var followings: [String:OtherPerson]? = nil
    var followers: [String:OtherPerson]? = nil
    var pendingFollowers: [String:OtherPerson]? = nil
    var pendingFollowings: [String:OtherPerson]? = nil
    var weights: [String:Weight]? = nil
    
    var followersList: [OtherPerson] {
        if followers?.values != nil {
            return Array(followers!.values).sorted { o1, o2 in
                o1.username < o2.username
            }
        } else {
            return []
        }
    }
    var followingsList: [OtherPerson] {
        if followings?.values != nil {
            return Array(followings!.values).sorted { o1, o2 in
                o1.username < o2.username
            }
        } else {
            return []
        }
    }
    var pendingFollowersList: [OtherPerson] {
        if pendingFollowers?.values != nil {
            return Array(pendingFollowers!.values).sorted { o1, o2 in
                o1.username < o2.username
            }
        } else {
            return []
        }
    }
    var pendingRequestsList: [OtherPerson] {
        if pendingFollowings?.values != nil {
            return Array(pendingFollowings!.values).sorted { o1, o2 in
                o1.username < o2.username
            }
        } else {
            return []
        }
    }
    var weightsList: [Weight] {
        if weights?.values != nil {
            return Array(weights!.values).sorted { w1, w2 in
                w1.dateTime.fromLongToDate() > w2.dateTime.fromLongToDate()
            }
        } else {
            return []
        }
    }
    
    var monthArray: [Month] {
        
        let grouped = Dictionary(grouping: weightsList) { (weight: Weight) -> String in
            weight.dateTime.toMonthYearDateString()
        }
        
        return grouped.map { month -> Month in
            Month(title: month.key, occurrences: month.value, date: month.value[0].dateTime.fromLongToDate())
                }.sorted { $0.date > $1.date }
    }
    
    var weightsListReversed: [Weight] {
        if weights?.values != nil {
            return Array(weights!.values).sorted { w1, w2 in
                w1.dateTime.fromLongToDate() < w2.dateTime.fromLongToDate()
            }
        } else {
            return []
        }
    }
}

struct Month: Identifiable {
    let id = UUID()
    let title: String
    let occurrences: [Weight]
    let date: Date
}

struct OtherPerson: Identifiable, Codable {
    var username: String
    var userId: String
    var profilePicUrl: String?
    
    var id: String {
        userId
    }
}

struct Weight: Identifiable, Codable {
    var id: String {
        dateTime + notes
    }
    var dateTime: String
    var notes: String
    var weight: Double
}
