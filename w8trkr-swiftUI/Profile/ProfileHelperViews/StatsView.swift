//
//  StatsView.swift
//  StatsView
//
//  Created by Trevor Schmidt on 8/20/21.
//

import SwiftUI

struct StatsView: View {
    @Binding var contentState: ContentState
    var weightsCount: Int
    var followersCount: Int
    var followingsCount: Int
    var body: some View {
        HStack {
            VStack {
                Button {
                    contentState = .weights
                } label: {
                    Text("\(weightsCount)")
                        .fontWeight(self.contentState == .weights ? .heavy : .regular)
                }
                Text("Weigh-Ins")
                    .fontWeight(self.contentState == .weights ? .heavy : .regular)
                    .font(.subheadline)
            }
            Spacer()
            VStack {
                Button {
                    contentState = .followers
                } label: {
                    Text("\(followersCount)")
                        .fontWeight(self.contentState == .followers ? .heavy : .light)
                }
                Text("Followers")
                    .fontWeight(self.contentState == .followers ? .heavy : .regular)
                    .font(.subheadline)
            }
            Spacer()
            VStack {
                Button {
                    contentState = .followings
                } label: {
                    Text("\(followingsCount)")
                        .fontWeight(self.contentState == .followings ? .heavy : .light)
                }
                Text("Following")
                    .fontWeight(self.contentState == .followings ? .heavy : .regular)
                    .font(.subheadline)
            }
        }
    }
}

