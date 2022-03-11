////
////  FormattedTextField.swift
////  w8trkr-ios
////
////  Created by Trevor Schmidt on 10/26/21.
////
//
//import SwiftUI
//
//struct FormattedTextField: View {
//    var prompt: String
//    @Binding var binding: String
//    var isSecure = false
//    
//    var body: some View {
//        Group {
//            if isSecure {
//                SecureField(prompt, text: $binding, prompt: nil)
//            } else {
//                TextField(prompt, text: $binding, prompt: nil)
//            }
//        }
//            .font(.caption)
//            .padding()
//            .background(Color(.secondarySystemBackground))
//            .cornerRadius(5.0)
//    }
//}
//
////struct FormattedTextField_Previews: PreviewProvider {
////    static var previews: some View {
////        FormattedTextField()
////    }
////}
