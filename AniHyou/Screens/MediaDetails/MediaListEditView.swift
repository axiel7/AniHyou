//
//  MediaListEditView.swift
//  AniHyou
//
//  Created by Axel Lopez on 20/6/22.
//

import SwiftUI

struct MediaListEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    var mediaId: Int
    var mediaType: MediaType
    var mediaList: MediaDetailsQuery.Data.Medium.MediaListEntry?
    
    @StateObject var viewModel = MediaListEditViewModel()
    @State var status: MediaListStatus = .planning
    @State var progress: Int = 0
    @State var progressVolumes: Int = 0
    @State var score: Double = 0
    @State var startDate: Date = Date()
    @State var isStartDateSet: Bool = false
    @State var finishDate: Date = Date()
    @State var isFinishDateSet: Bool = false
    @State var showStartDate = false
    @State var showFinishDate = false
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Status", selection: $status) {
                    ForEach(MediaListStatus.allCases, id: \.self) { status in
                        Text(status.localizedName)
                    }
                }
                
                Section {
                    HStack {
                        TextField("", value: $score, formatter: formatter)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        Stepper("Score", value: $score, in: 0...10, step: 0.5)
                    }
                }
                
                Section("Progress") {
                    HStack {
                        TextField("", value: $progress, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 80)
                        Stepper("Episodes", value: $progress, in: 0...Int.max)
                    }
                    if mediaType == .manga {
                        HStack {
                            TextField("", value: $progressVolumes, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 80)
                            Stepper("Volumes", value: $progressVolumes, in: 0...Int.max)
                        }
                    }
                }
                
                Section("Dates") {
                    DatePickerToggleView(text: "Start Date", selection: $startDate, isDateSet: $isStartDateSet)
                    DatePickerToggleView(text: "Finish Date", selection: $finishDate, isDateSet: $isFinishDateSet)
                }
                
                Button("Delete", role: .destructive) {
                    
                }
                
            }//:Form
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                    
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.updateEntry(mediaId: mediaId, status: status, score: score, progress: progress, progressVolumes: progressVolumes, startedAt: isStartDateSet ? startDate : nil, completedAt: isFinishDateSet ? finishDate : nil)
                    }
                    .font(.bold(.body)())
                }
            }//:Toolbar
        }//:NavigationView
        .onAppear {
            setValues()
        }
        .onChange(of: viewModel.isUpdateSuccess) { isUpdateSuccess in
            if isUpdateSuccess {
                dismiss()
            }
        }
    }
    
    private func setValues() {
        self.status = self.mediaList?.status ?? .planning
        self.progress = self.mediaList?.progress ?? 0
        self.progressVolumes = self.mediaList?.progressVolumes ?? 0
        self.score = self.mediaList?.score ?? 0
        if let startedYear = self.mediaList?.startedAt?.year {
            if let startedMonth = self.mediaList?.startedAt?.month {
                if let startedDay = self.mediaList?.startedAt?.day {
                    if let startDate = date(year: startedYear, month: startedMonth, day: startedDay) {
                        self.startDate = startDate
                    }
                }
            }
        }
        self.isStartDateSet = self.mediaList?.startedAt?.year != nil
        
        if let completedYear = self.mediaList?.completedAt?.year {
            if let completedMonth = self.mediaList?.completedAt?.month {
                if let completedDay = self.mediaList?.completedAt?.day {
                    if let finishDate = date(year: completedYear, month: completedMonth, day: completedDay) {
                        self.finishDate = finishDate
                    }
                }
            }
        }
        self.isFinishDateSet = self.mediaList?.completedAt?.year != nil
    }
}

struct MediaListEditView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListEditView(mediaId: 1, mediaType: .anime)
    }
}
