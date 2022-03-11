//
//  AddWeightView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 10/31/21.
//

import SwiftUI
import Combine

struct AddWeightView: View {
    
    @StateObject var viewModel = AddWeightViewModel()
    
    @FocusState private var focusedField: Field?
    var body: some View {
        Form {
            Section("Weigh-In") {
                DatePicker(selection: $viewModel.model.date, in: ...Date(), displayedComponents: .date) {
                    Text("Date: ")
                }
                HStack {
                    Text("Weight:")
                    Spacer()
                    TextField("weight", text: $viewModel.model.weight, prompt: nil)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onReceive(Just(viewModel.model.weight)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                viewModel.model.weight = filtered
                            }
                        }
                        .focused($focusedField, equals: .weight)
                        .onSubmit {
                            focusedField = .notes
                        }
                }
                HStack {
                    Text("Notes: ")
                    Spacer()
                    TextField("optional", text: $viewModel.model.notes, prompt: nil)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .notes)
                        .onSubmit {
                            focusedField = nil
                        }
                }
                
                
                HStack {
                    Spacer()
                    Button("Weigh-In") {
                        viewModel.submit()
                        focusedField = nil
                    }
                        .disabled(!viewModel.canSubmit)
                        .tint(viewModel.canSubmit ? AppViewModel.shared.accentColor : .gray)
                    Spacer()
                }
            }
            
            Section("Update Goal") {
                HStack {
                    Text("Weight:")
                    Spacer()
                    TextField("weight", text: $viewModel.model.goalWeight, prompt: nil)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .onReceive(Just(viewModel.model.goalWeight)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                viewModel.model.goalWeight = filtered
                            }
                        }
                        .focused($focusedField, equals: .goalWeight)
                        .onSubmit {
                            focusedField = nil
                        }
                }
                HStack {
                    Spacer()
                    Button("Update Goal") {
                        viewModel.updateGoal()
                        focusedField = nil
                    }
                        .disabled(!viewModel.canUpdate)
                        .tint(viewModel.canUpdate ? AppViewModel.shared.accentColor : .gray)
                    Spacer()
                }
            }
        }
            .navigationTitle("Add Weight")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button(action: selectPreviousField) {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(!canSelectPreviousField)
                    Button(action: selectNextField) {
                        Image(systemName: "chevron.down")
                    }
                    .disabled(!canSelectNextField)
                    Spacer()
                    
                    Button {
                        focusedField = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
    }
}

extension AddWeightView {
    // Focused Fields code
    private enum Field: Int, Hashable {
        case weight, notes, goalWeight
    }
    private func selectPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1)!
        }
    }
    private func selectNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1)!
        }
    }
    private var canSelectPreviousField: Bool {
        if let currentFocusedField = focusedField {
            return currentFocusedField.rawValue > 0
        }
        return false
    }
    private var canSelectNextField: Bool {
        if let currentFocusedField = focusedField {
            return currentFocusedField.rawValue < 2
        }
        return false
    }
}

struct AddWeightView_Previews: PreviewProvider {
    static var previews: some View {
        AddWeightView()
    }
}
