//
//  WeightContentView.swift
//  w8trkr-ios
//
//  Created by Trevor Schmidt on 11/3/21.
//

import SwiftUI
import Combine

struct WeightContentView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var selfUserId = FirebaseAuthService.shared.getUserId()
    @State private var selectedLayout = 0
    @State private var isUpdatingWeight = false
    @State private var selectedEditWeight = ""
    @State private var selectedEditNotes = ""
    @State private var selectedEditDate = Date()
    
    var body: some View {
        Picker("Choose Layout", selection: $selectedLayout) {
            Image(systemName: "chart.xyaxis.line").tag(0)
            Image(systemName: "list.dash").tag(1)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        if !viewModel.loading {
            GeometryReader { proxy in
                if viewModel.model.weightsList.count > 0 {
                    GraphView(proxy: proxy, weights: viewModel.model.weightsListReversed)
                        .opacity(selectedLayout == 0 ? 1 : 0)
                    List {
                        
                        ForEach(viewModel.model.monthArray) { month in
                            Section(header: Text(month.title)) {
                                ForEach(month.occurrences) { weight in
                                    HStack {
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(weight.dateTime.toPrettyFormattedDateString())")
                                            if !weight.notes.isEmpty {
                                                Text(weight.notes)
                                                    .font(.caption)
                                            }
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing ) {
                                            Text("\(weight.weight.formatted())")
                                            Text("lbs")
                                                .font(.caption)
                                        }
                                        
                                    }
                                    .swipeActions {
                                        
                                        Button {
                                            viewModel.deleteWeighIn(weighIn: weight)
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                            .tint(.red)
                                            .disabled(FirebaseAuthService.shared.getUserId() ?? "" != viewModel.model.userId)
                                        
                                        Button {
                                            selectedEditDate = weight.dateTime.fromLongToDate()
                                            selectedEditNotes = weight.notes
                                            selectedEditWeight = String(weight.weight.formatted())
                                            isUpdatingWeight.toggle()
                                        } label: {
                                            Image(systemName: "pencil")
                                        }
                                            .tint(.gray)
                                            .disabled(FirebaseAuthService.shared.getUserId() ?? "" != viewModel.model.userId)
                                        
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    .opacity(selectedLayout == 1 ? 1 : 0)
                } else {
                    if let selfUserId = selfUserId {
                        Text("\(selfUserId == viewModel.model.userId ? "You Have" : viewModel.model.username + " Has") No Weigh-Ins")
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .sheet(isPresented: $isUpdatingWeight, onDismiss: nil) {
                Form {
                    Section("Weigh-In") {
                        DatePicker(selection: $selectedEditDate, in: ...Date(), displayedComponents: .date) {
                            Text("Date: ")
                        }
                        HStack {
                            Text("Weight:")
                            Spacer()
                            TextField("weight", text: $selectedEditWeight, prompt: nil)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.decimalPad)
                                .onReceive(Just(selectedEditWeight)) { newValue in
                                    let filtered = newValue.filter { "0123456789.".contains($0) }
                                    if filtered != newValue {
                                        selectedEditWeight = filtered
                                    }
                                }
                        }
                        HStack {
                            Text("Notes: ")
                            Spacer()
                            TextField("optional", text: $selectedEditNotes, prompt: nil)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        
                        HStack {
                            Spacer()
                            Button("Update Weight") {
                                viewModel.updateWeighIn(dateTime: selectedEditDate.toLongString(), weight: Double(selectedEditWeight)!, notes: selectedEditNotes)
                            }
                                .disabled(Double(selectedEditWeight) == nil)
                                .tint(Double(selectedEditWeight) != nil ? AppViewModel.shared.accentColor : .gray)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button("Cancel") {
                                isUpdatingWeight.toggle()
                            }
                                .tint(AppViewModel.shared.accentColor)
                            Spacer()
                        }
                    }
                }
            }
        } else {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
    }
}

//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView()
//    }
//}
