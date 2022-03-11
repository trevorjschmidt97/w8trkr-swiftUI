//
//  SearchViewModel.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/2/21.
//

import Foundation

class SearchViewModel: ObservableObject {
    
    @Published var model = SearchModel()
    @Published var loading = false
    
    func onAppear() {
        loading = true
        FirebaseDbService.shared.pullSearchUsers { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {

                switch result {
                case .success(let searchModel):
                    self.model = searchModel
                    self.model.users.sort { u1, u2 in
                        u1.username < u2.username
                    }
                    self.loading = false
                case .failure(let error):
                    print("Error")
                    print(error.localizedDescription)
                    AppViewModel.shared.showAlert(title: "Oops", message: "Unable To Search Users")
                }
            }
        }
    }
}
