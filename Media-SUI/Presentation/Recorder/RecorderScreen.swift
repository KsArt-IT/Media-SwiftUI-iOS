//
//  RecorderScreen.swift
//  Media-SUI
//
//  Created by KsArT on 27.11.2024.
//

import SwiftUI

struct RecorderScreen: View {
    @StateObject private var viewModel = RecorderViewModel()
    
    var body: some View {
        VStack {
            TitleTextView("Audio recorder")
            
            Text("Recordings")
                .font(.title2)
                .fontWeight(.semibold)
            //                .foregroundStyle(Color.white)
                .padding(.vertical, Constants.small)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: Constants.small) {
                    ForEach(viewModel.recordings) { recording in
                        RecordingView(
                            recording: recording,
                            isPlaying: viewModel.isPlaying(recording.url)
                        )
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.delete(recording.url)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .onTapGesture {
                            viewModel.playOrStop(recording.url)
                        }
                    }
                }
            }
            .frame(maxHeight: 300)
            
            Spacer()
            
            VStack {
                if viewModel.isRecording {
                    AudioWaveformView(audioLevels: viewModel.audioLevels)
                } else {
                    EmptyView()
                }
            }
            .frame(height: 150)
            .padding(.vertical, Constants.small)
            .border(.green)
            
            ButtonRecordingView(isRecording: viewModel.isRecording, isDisabled: viewModel.isRecordingButtonDisabled) {
                viewModel.startOrStopRecording()
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .onAppear {
            viewModel.fetchRecordings()
        }
        .onReceive(NotificationCenter.default.publisher(for: .playbackFinished)) { _ in
            viewModel.stop()
        }
    }
}

#Preview {
    RecorderScreen()
}
