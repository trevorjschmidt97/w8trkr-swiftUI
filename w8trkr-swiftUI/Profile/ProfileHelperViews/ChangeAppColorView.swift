//
//  ChangeAppColorView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/10/21.
//

import SwiftUI

struct ChangeAppColorView: View {
    @Binding var alertIsPresented: Bool
    
    var body: some View {
        Button("Blue") {
            AppViewModel.shared.accentColorString = "blue"
            reRenderAlertButton()
        }
        Button("Brown") {
            AppViewModel.shared.accentColorString = "brown"
            reRenderAlertButton()
        }
        Button("Cyan") {
            AppViewModel.shared.accentColorString = "cyan"
            reRenderAlertButton()
        }
        Button("Green") {
            AppViewModel.shared.accentColorString = "green"
            reRenderAlertButton()
        }
        Button("Orange") {
            AppViewModel.shared.accentColorString = "orange"
            reRenderAlertButton()
        }
        Button("Purple") {
            AppViewModel.shared.accentColorString = "purple"
            reRenderAlertButton()
        }
        Button("Red") {
            AppViewModel.shared.accentColorString = "red"
            reRenderAlertButton()
        }
        Button("Yellow") {
            AppViewModel.shared.accentColorString = "yellow"
            reRenderAlertButton()
        }
    }
    
    func reRenderAlertButton() {
        alertIsPresented.toggle()
        alertIsPresented.toggle()
        
        UINavigationBar.appearance().tintColor = UIColor(AppViewModel.shared.accentColor)
    }
}

//struct ChangeAppColorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeAppColorView()
//    }
//}
