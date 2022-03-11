//
//  FirebaseDbService.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/26/21.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

enum DbError: Error {
    case noData
}

struct FirebaseDbService {
    static let shared = FirebaseDbService()
    
    private init() { }
    
    private struct Key {
        static let usernames = "usernames"
        static let search = "search"
        static let userId = "userId"
        static let username = "username"
        static let email = "email"
        static let users = "users"
        static let isPrivate = "isPrivate"
        static let weights = "weights"
        static let goalWeight = "goalWeight"
        static let weight = "weight"
        static let notes = "notes"
        static let dateTime = "dateTime"
        static let followers = "followers"
        static let followings = "followings"
        static let pendingFollowings = "pendingFollowings"
        static let pendingFollowers = "pendingFollowers"
        static let profilePicUrl = "profilePicUrl"
    }
    
    private let rootRef = Database.database().reference()
    
    func pullUsernames(completion: @escaping (Result<Set<String>,Error>) -> Void) {
        rootRef.child(Key.usernames).observe(.value) { snapshot in
            
            guard let snapDict = snapshot.value as? [String:String] else {
                completion(.failure(DbError.noData))
                return
            }
            completion(.success(Set(Array(snapDict.values))))
        }
    }
    
    func register(userId: String, username: String, email: String, currentWeight: Double, goalWeight: Double) {
        // Set usernames
        rootRef.child(Key.usernames).child(userId).setValue(username)
        
        // Set search
        rootRef.child(Key.search).child(userId).setValue([
            Key.username: username,
            Key.email: email,
            Key.userId: userId
        ])
        
        // Set user
        rootRef.child(Key.users).child(userId).setValue([
            Key.userId: userId,
            Key.username: username,
            Key.email: email,
            Key.isPrivate: true,
            Key.goalWeight: goalWeight
        ])
        
        // Set user's weight
        let date = Date()
        rootRef.child(Key.users).child(userId).child(Key.weights).child(date.toLongString()).setValue([
            Key.weight: currentWeight,
            Key.notes: "",
            Key.dateTime: date.toLongString()
        ])
    }
    
    func pullUsername(userId: String, completion: @escaping (String?) -> Void) {
        rootRef.child(Key.usernames).child(userId).observe(.value) { snapshot in
            guard let username = snapshot.value as? String else {
                completion(nil)
                return
            }
            completion(username)
        }
    }
    
    func pullUserInfo(uniqueUserId: String, completion: @escaping (Result<AppModel, Error>) -> Void) {
        rootRef.child(Key.users).child(uniqueUserId).observe(.value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else {
                completion(.failure(DbError.noData))
                return }
            
            var followersSet: Set<String> = []
            var followingsSet: Set<String> = []
            var pendingFollowersSet: Set<String> = []
            var pendingRequestsSet: Set<String> = []
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == Key.followers {
                    guard let followersDict = snapVal as? [String:Any] else {
                        completion(.failure(DbError.noData))
                        return
                    }
                    followersSet = Set(Array(followersDict.keys))
                } else if snapKey == Key.followings {
                    guard let followingsDict = snapVal as? [String:Any] else {
                        completion(.failure(DbError.noData))
                        return
                    }
                    followingsSet = Set(Array(followingsDict.keys))
                } else if snapKey == Key.pendingFollowers {
                    guard let pendingFollowersDict = snapVal as? [String:Any] else {
                        completion(.failure(DbError.noData))
                        return
                    }
                    pendingFollowersSet = Set(Array(pendingFollowersDict.keys))
                } else if snapKey == Key.pendingFollowings {
                    guard let pendingRequestsDict = snapVal as? [String:Any] else {
                        completion(.failure(DbError.noData))
                        return
                    }
                    pendingRequestsSet = Set(Array(pendingRequestsDict.keys))
                }
            }
            
            completion(.success(AppModel(followersSet: followersSet, followingsSet: followingsSet, pendingFollowersSet: pendingFollowersSet, pendingRequestsSet: pendingRequestsSet)))
        }
    }
    
    func pullProfileInfo(of userId: String, completion: @escaping (Result<ProfileModel, Error>) -> Void) {
        rootRef.child(Key.users).child(userId).observe(.value) { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DbError.noData))
                return
            }
            
            do {
                let model = try FirebaseDecoder().decode(ProfileModel.self, from: value)
                completion(.success(model))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func follow(selfUserId: String, otherUserId: String, otherUsername: String, otherProfilePicUrl: String?) {
        
        // put other person's info in self's followings
        rootRef.child(Key.users).child(selfUserId).child(Key.followings).child(otherUserId).setValue([
            Key.userId: otherUserId,
            Key.username: otherUsername,
            Key.profilePicUrl: otherProfilePicUrl
        ])
        
        // put self's info in other person's followers
        rootRef.child(Key.users).child(selfUserId).observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else {
                return
            }
            var selfUsername: String = ""
            var selfProfilePicUrl: String? = nil
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == Key.username {
                    selfUsername = snapVal as! String
                } else if snapKey == Key.profilePicUrl {
                    let ppurl = snapVal as! String
                    selfProfilePicUrl = ppurl
                }
            }
            
            rootRef.child(Key.users).child(otherUserId).child(Key.followers).child(selfUserId).setValue([
                Key.userId: selfUserId,
                Key.username: selfUsername,
                Key.profilePicUrl: selfProfilePicUrl
            ])
        }
    }
    
    func unFollow(selfUserId: String, otherUserId: String) {
        // take out self's info from other's followers
        rootRef.child(Key.users).child(otherUserId).child(Key.followers).child(selfUserId).setValue(nil)
        
        // take out other's info from self's followings
        rootRef.child(Key.users).child(selfUserId).child(Key.followings).child(otherUserId).setValue(nil)
    }
    
    func request(selfUserId: String, otherUserId: String, otherUsername: String, otherProfilePicUrl: String?) {
        // put other person's info in self's pendingRequests
        rootRef.child(Key.users).child(selfUserId).child(Key.pendingFollowings).child(otherUserId).setValue([
            Key.userId: otherUserId,
            Key.username: otherUsername,
            Key.profilePicUrl: otherProfilePicUrl
        ])
        
        // put self's info in other person's pendingFollowers
        rootRef.child(Key.search).child(selfUserId).observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else {
                return
            }
            var selfUsername: String = ""
            var selfProfilePicUrl: String? = nil
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == Key.username {
                    selfUsername = snapVal as! String
                } else if snapKey == Key.profilePicUrl {
                    let ppurl = snapVal as! String
                    selfProfilePicUrl = ppurl
                }
            }
            
            rootRef.child(Key.users).child(otherUserId).child(Key.pendingFollowers).child(selfUserId).setValue([
                Key.userId: selfUserId,
                Key.username: selfUsername,
                Key.profilePicUrl: selfProfilePicUrl
            ])
        }
    }
    
    func cancelFollowRequest(from fromUserId: String, to toUserId: String) {
        // take out toUser's info from fromUser's pendingRequests
        rootRef.child(Key.users).child(fromUserId).child(Key.pendingFollowings).child(toUserId).setValue(nil)
        
        // take out fromUser's info from toUser's pendingFollowers
        rootRef.child(Key.users).child(toUserId).child(Key.pendingFollowers).child(fromUserId).setValue(nil)
    }
    
    func acceptPendingFollower(selfUserId: String, selfUsername: String, selfProfilePic: String?,
                               otherUserId: String, otherUsername: String, otherProfilePicUrl: String?) {
        rootRef.child(Key.users).child(selfUserId).child(Key.pendingFollowers).child(otherUserId).setValue(nil)
        rootRef.child(Key.users).child(otherUserId).child(Key.pendingFollowings).child(selfUserId).setValue(nil)
        rootRef.child(Key.users).child(selfUserId).child(Key.followers).child(otherUserId).setValue([
            Key.userId: otherUserId,
            Key.username: otherUsername,
            Key.profilePicUrl: otherProfilePicUrl
        ])
        rootRef.child(Key.users).child(otherUserId).child(Key.followings).child(selfUserId).setValue([
            Key.userId: selfUserId,
            Key.username: selfUsername,
            Key.profilePicUrl: selfProfilePic
        ])
    }
    
    func rejectPendingFollower(selfUserId: String, otherUserId: String) {
        rootRef.child(Key.users).child(selfUserId).child(Key.pendingFollowers).child(otherUserId).setValue(nil)
        rootRef.child(Key.users).child(otherUserId).child(Key.pendingFollowings).child(selfUserId).setValue(nil)
    }
    
    func updatePrivacy(userId: String, newPrivacy: Bool) {
        rootRef.child(Key.users).child(userId).child(Key.isPrivate).setValue(newPrivacy)
    }
    
    func updateProfilePicUrl(userId: String, profilePicUrl: String) {
        // in self's spot
        rootRef.child(Key.users).child(userId).child(Key.profilePicUrl).setValue(profilePicUrl)
        
        // in search
        rootRef.child(Key.search).child(userId).child(Key.profilePicUrl).setValue(profilePicUrl)
        
        // in all of the user's followers/followings/otherstuff
        rootRef.child(Key.users).child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let snapDict = snapshot.value as? [String:Any] else { return }
            
            var followersList: [String] = []
            var followingsList: [String] = []
            var pendingFollowersList: [String] = []
            var pendingRequestsList: [String] = []
            
            for (snapKey, snapVal) in snapDict {
                if snapKey == Key.followers {
                    guard let followersDict = snapVal as? [String:Any] else { return }
                    followersList = Array(followersDict.keys)
                } else if snapKey == Key.followings {
                    guard let followingsDict = snapVal as? [String:Any] else { return }
                    followingsList = Array(followingsDict.keys)
                } else if snapKey == Key.pendingFollowers {
                    guard let pendingFollowersDict = snapVal as? [String:Any] else { return }
                    pendingFollowersList = Array(pendingFollowersDict.keys)
                } else if snapKey == Key.pendingFollowings {
                    guard let pendingRequestsDict = snapVal as? [String:Any] else { return }
                    pendingRequestsList = Array(pendingRequestsDict.keys)
                }
            }
            
            for follower in followersList {
                rootRef.child(Key.users).child(follower).child(Key.followings).child(userId).child(Key.profilePicUrl).setValue(profilePicUrl)
            }
            for following in followingsList {
                rootRef.child(Key.users).child(following).child(Key.followers).child(userId).child(Key.profilePicUrl).setValue(profilePicUrl)
            }
            for pendingFollower in pendingFollowersList {
                rootRef.child(Key.users).child(pendingFollower).child(Key.pendingFollowings).child(userId).child(Key.profilePicUrl).setValue(profilePicUrl)
            }
            for pendingRequest in pendingRequestsList {
                rootRef.child(Key.users).child(pendingRequest).child(Key.pendingFollowers).child(userId).child(Key.profilePicUrl).setValue(profilePicUrl)
            }
        }
        
    }
    
    func deleteWeight(userId: String, dateTime: String) {
        rootRef.child(Key.users).child(userId).child(Key.weights).child(dateTime).setValue(nil)
    }
    
    func updateWeight(userId: String, dateTime: String, weight: Double, notes: String) {
        rootRef.child(Key.users).child(userId).child(Key.weights).child(dateTime).setValue([
            Key.dateTime: dateTime,
            Key.notes: notes,
            Key.weight: weight
        ])
    }
    
    func addWeight(userId: String, weight: Double, notes: String, dateTime: String) {
        rootRef.child(Key.users).child(userId).child(Key.weights).child(dateTime).setValue([
            Key.dateTime: dateTime,
            Key.notes: notes,
            Key.weight: weight
        ])
    }
    
    func updateGoalWeight(userId: String, weight: Double) {
        rootRef.child(Key.users).child(userId).child(Key.goalWeight).setValue(weight)
    }
    
    func pullSearchUsers(completion: @escaping (Result<SearchModel, Error>) -> Void) {
        rootRef.child(Key.search).observe(.value) { snapshot in
            guard let snapDict = snapshot.value as? [String: Any] else {
                completion(.failure(DbError.noData))
                return }
            
            var users: [SearchUser] = []
            
            for (userId, userInfo) in snapDict {
                guard let userInfo = userInfo as? [String:Any] else {
                    completion(.failure(DbError.noData))
                    return
                }
                
                var username = ""
                var email = ""
                var profilePicUrl: String? = nil
                
                for (userInfoKey, userInfoVal) in userInfo {
                    if userInfoKey == Key.username {
                        username = userInfoVal as! String
                    } else if userInfoKey == Key.email {
                        email = userInfoVal as! String
                    } else if userInfoKey == Key.profilePicUrl {
                        let ppurl = userInfoVal as! String
                        profilePicUrl = ppurl
                    }
                }
                
                let user = SearchUser(userId: userId, username: username, email: email, profilePicUrl: profilePicUrl)
                users.append(user)
            }
            
            let searchModel = SearchModel(users: users)
            completion(.success(searchModel))
        }
    }
    
}
