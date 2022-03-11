//
//  ProfileImageView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/3/21.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    var username: String
    var profilePicUrl: String?
    var size: Double
    
    var body: some View {
        Group {
            if let profilePicUrl = profilePicUrl {
                KFImage(URL(string: profilePicUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(.secondary, lineWidth: 2))
            } else {
                ZStack {
                    Circle()
                        .fill(.gray)
                        .opacity(50)
                        .overlay(Circle().stroke(.secondary, lineWidth: 2))
                        .frame(width: size, height: size)
                    
                    Text("\(String(username.first ?? Character(" ")))")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: size, height: size)
                }
            }
        }
        .padding(.trailing)
    }
}

//struct ProfileImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileImageView()
//    }
//}
