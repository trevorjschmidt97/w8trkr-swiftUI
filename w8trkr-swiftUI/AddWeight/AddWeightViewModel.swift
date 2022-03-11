//
//  AddWeightViewModel.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/4/21.
//

import Foundation

class AddWeightViewModel: ObservableObject {
    
    @Published var model = AddWeightModel()
    
    var canSubmit: Bool {
        if let doubleVal = Double(model.weight), doubleVal > 50 && doubleVal < 1000 {
            if model.date <= Date() {
                return true
            }
        }
        return false
    }
    
    var canUpdate: Bool {
        if let doubleVal = Double(model.goalWeight), doubleVal > 50 && doubleVal < 1000 {
            return true
        }
        return false
    }
    
    func submit() {
        guard let selfUserId = FirebaseAuthService.shared.getUserId() else { return }
        guard let doubleWeight = Double(model.weight) else { return }
        FirebaseDbService.shared.addWeight(userId: selfUserId,
                                           weight: doubleWeight,
                                           notes: model.notes,
                                           dateTime: model.date.toLongString())
        model.weight = ""
        model.notes = ""
        AppViewModel.shared.showSuccess(title: "Weight Submitted")
        
    }
    
    func updateGoal() {
        guard let selfUserId = FirebaseAuthService.shared.getUserId() else { return }
        guard let doubleWeight = Double(model.goalWeight) else { return }
        FirebaseDbService.shared.updateGoalWeight(userId: selfUserId, weight: doubleWeight)
        model.goalWeight = ""
        AppViewModel.shared.showSuccess(title: "Goal Updated")
    }
}
